/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_application_native_manifest.c
 *
 * PURPOSE:
 *   Validate every checked-in frontend declaration against the one canonical
 *   Framework GUI catalogue without building, launching or inspecting binaries.
 *
 * AUTHOR AND ORGANISATION: Sammy Hegab, Umicom Foundation
 * LICENCE: MIT
 *---------------------------------------------------------------------------*/
#include "umicom/application/portfolio.h"
#include "umicom/platform/directory.h"
#include "umicom/platform/filesystem.h"
#include "umicom/runtime/application_manifest.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef UMICOM_APPLICATIONS_SOURCE_DIR
#error "UMICOM_APPLICATIONS_SOURCE_DIR must identify the composition root"
#endif

typedef struct NativeManifestFixture {
    unsigned char *seen;
    UmiApplicationManifest *manifest;
    UmiApplicationLaunchSpec *declarations;
    size_t portfolio_count;
    size_t visited_count;
} NativeManifestFixture;

/* Parse real source manifests through the same API as production discovery.
 * Never construct another expected executable-name table in a test. */
static UmiStatus inspect_manifest(const UmiFileInfo *info, void *data)
{
    NativeManifestFixture *fixture = data;
    UmiApplicationLaunchSpec spec;
    UmiApplicationManifest *manifest = fixture->manifest;
    const char *canonical;
    size_t portfolio_index;
    UmiStatus status;
    if (info->kind != UMI_FILE_KIND_REGULAR ||
        strcmp(info->name, "application.umicom.yaml") != 0) return UMI_STATUS_OK;
    status = umi_application_manifest_load_with_launch_spec(info->path, manifest, &spec);
    if (status != UMI_STATUS_OK) return status;
    canonical = umi_application_portfolio_gui_executable(manifest->id);
    if (canonical == NULL || strcmp(spec.native_executable, canonical) != 0 ||
        spec.console_executable[0] == '\0' ||
        strcmp(spec.native_executable, spec.console_executable) == 0 ||
        (manifest->frontends & (UMI_FRONTEND_GTK4 | UMI_FRONTEND_CONSOLE)) !=
            (UMI_FRONTEND_GTK4 | UMI_FRONTEND_CONSOLE))
        return UMI_STATUS_INVALID_STATE;
    for (portfolio_index = 0U; portfolio_index < fixture->portfolio_count; ++portfolio_index) {
        const UmiApplicationDefinition *definition =
            umi_application_portfolio_at(portfolio_index);
        if (strcmp(definition->application_id, manifest->id) == 0) break;
    }
    if (portfolio_index == fixture->portfolio_count) return UMI_STATUS_NOT_FOUND;
    if (fixture->seen[portfolio_index]) return UMI_STATUS_ALREADY_EXISTS;

    /* A GUI name cannot collide with another product's GUI or console. */
    for (size_t index = 0U; index < fixture->portfolio_count; ++index) {
        const UmiApplicationLaunchSpec *other = &fixture->declarations[index];
        if (!fixture->seen[index]) continue;
        if (strcmp(spec.native_executable, other->native_executable) == 0 ||
            strcmp(spec.native_executable, other->console_executable) == 0 ||
            strcmp(spec.console_executable, other->native_executable) == 0 ||
            strcmp(spec.console_executable, other->console_executable) == 0)
            return UMI_STATUS_ALREADY_EXISTS;
    }
    fixture->seen[portfolio_index] = 1U;
    fixture->declarations[portfolio_index] = spec;
    ++fixture->visited_count;
    return UMI_STATUS_OK;
}

/* A read-only directory walk proves coverage of all registered native products,
 * including those disabled in the current build, with no personal state I/O. */
int main(void)
{
    NativeManifestFixture fixture = {0};
    UmiDirectoryWalkOptions options = umi_directory_walk_options_default();
    char application_root[UMI_PATH_CAPACITY];
    size_t expected_count = 0U;
    UmiStatus status;
    int failed = 1;
    fixture.portfolio_count = umi_application_portfolio_count();
    fixture.seen = calloc(fixture.portfolio_count, sizeof(*fixture.seen));
    fixture.declarations = calloc(fixture.portfolio_count, sizeof(*fixture.declarations));
    fixture.manifest = calloc(1U, sizeof(*fixture.manifest));
    if (fixture.seen == NULL || fixture.declarations == NULL || fixture.manifest == NULL)
        goto cleanup;
    status = umi_fs_join(application_root, sizeof(application_root),
        UMICOM_APPLICATIONS_SOURCE_DIR, "applications");
    if (status != UMI_STATUS_OK) goto cleanup;
    options.recursive = 1;
    options.max_depth = 1U;
    options.include_files = 1;
    options.include_directories = 0;
    options.include_hidden = 0;
    options.follow_symbolic_links = 0;
    status = umi_directory_walk(application_root, &options, inspect_manifest, &fixture);
    if (status != UMI_STATUS_OK) {
        (void)fprintf(stderr, "Native manifest declarations: %s\n", umi_status_text(status));
        goto cleanup;
    }
    for (size_t index = 0U; index < fixture.portfolio_count; ++index) {
        const UmiApplicationDefinition *definition = umi_application_portfolio_at(index);
        if (umi_application_portfolio_gui_executable(definition->application_id) != NULL) {
            ++expected_count;
            if (!fixture.seen[index]) {
                (void)fprintf(stderr, "Missing manifest: %s\n", definition->application_id);
                goto cleanup;
            }
        }
    }
    if (expected_count != 24U || fixture.visited_count != expected_count) goto cleanup;
    failed = 0;
cleanup:
    free(fixture.manifest);
    free(fixture.declarations);
    free(fixture.seen);
    return failed;
}

