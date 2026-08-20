/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_application_composition.c
 *
 * PURPOSE:
 *   Verify the Framework/Studio composition baseline, repository catalogue,
 *   architecture decisions and shared-resource ownership expected by the
 *   runnable multi-application superproject.
 *
 * AUTHOR AND ORGANISATION:
 *   Sammy Hegab
 *   Umicom Foundation
 *
 * LICENCE:
 *   MIT
 *---------------------------------------------------------------------------*/
#include "umicom/base/version.h"

#include <stdio.h>
#include <string.h>
#include <sys/stat.h>

#ifndef UMICOM_APPLICATIONS_SOURCE_DIR
#error "UMICOM_APPLICATIONS_SOURCE_DIR must identify the composition root"
#endif

#define UMICOM_APPLICATIONS_PATH_CAPACITY 1024U

static int make_path(char *destination,
                     size_t capacity,
                     const char *relative_path)
{
    const int written = snprintf(destination,
                                 capacity,
                                 "%s/%s",
                                 UMICOM_APPLICATIONS_SOURCE_DIR,
                                 relative_path);
    return written >= 0 && (size_t)written < capacity;
}

static int path_is_file(const char *relative_path)
{
    char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
    struct stat information;
    if (!make_path(path, sizeof(path), relative_path)) return 0;
    if (stat(path, &information) != 0) return 0;
    return S_ISREG(information.st_mode) != 0;
}

static int path_is_directory(const char *relative_path)
{
    char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
    struct stat information;
    if (!make_path(path, sizeof(path), relative_path)) return 0;
    if (stat(path, &information) != 0) return 0;
    return S_ISDIR(information.st_mode) != 0;
}

static int file_contains(const char *relative_path, const char *expected_text)
{
    char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
    char line[4096];
    FILE *stream;
    if (!make_path(path, sizeof(path), relative_path)) return 0;
    stream = fopen(path, "r");
    if (stream == NULL) return 0;
    while (fgets(line, (int)sizeof(line), stream) != NULL) {
        if (strstr(line, expected_text) != NULL) {
            (void)fclose(stream);
            return 1;
        }
    }
    (void)fclose(stream);
    return 0;
}

static int require_condition(int condition, const char *message)
{
    if (!condition) {
        (void)fprintf(stderr, "[FAIL] %s\n", message);
        return 0;
    }
    (void)printf("[PASS] %s\n", message);
    return 1;
}

int main(void)
{
    static const char *const module_directories[] = {
        "applications/desktop",
        "applications/studio",
        "applications/trader",
        "applications/tms",
        "applications/llm",
        "applications/bank",
        "applications/exchange",
        "applications/os",
    };
    static const char *const repository_names[] = {
        "umicom-foundation/umicom-framework",
        "umicom-foundation/umicom-desktop-module",
        "umicom-foundation/umicom-studio-ide-module",
        "umicom-foundation/umicom-trader-module",
        "umicom-foundation/umicom-tms-module",
        "umicom-foundation/umicom-llm-module",
        "umicom-foundation/umicom-bank-module",
        "umicom-foundation/umicom-exchange-module",
        "umicom-foundation/umicom-os-module",
    };
    static const char *const architecture_decisions[] = {
        "docs/architecture/ADR-0001-framework-shared-resources.md",
        "docs/architecture/ADR-0002-linux-kernel-boundary.md",
        "docs/architecture/ADR-0003-desktop-and-os-modules.md",
        "docs/architecture/ADR-0004-layout-ownership-and-persistence.md",
        "docs/architecture/ADR-0005-framework-sdk-and-runtime.md",
        "docs/architecture/ADR-0006-desk-taskbar-and-discovery.md",
        "docs/architecture/ADR-0007-application-runtime-and-launcher.md",
        "docs/architecture/ADR-0008-os-control-centre-boundary.md",
        "docs/architecture/REPOSITORY-TOPOLOGY.md",
    };
    static const char *const framework_resource_files[] = {
        "framework/resources/resource-catalogue.json",
        "framework/resources/application-presentations.json",
        "framework/resources/icons/application-icon-map.json",
        "framework/resources/themes/umicom-dark.tokens.json",
        "framework/resources/themes/umicom-light.tokens.json",
        "framework/resources/themes/umicom-high-contrast.tokens.json",
        "framework/resources/schemas/resource-catalogue.schema.json",
        "framework/resources/schemas/application-presentation.schema.json",
        "framework/resources/schemas/layout.schema.json",
        "framework/resources/layouts/templates/blank.umilayout",
        "framework/resources/layouts/templates/mosaic.umilayout",
        "framework/resources/layouts/templates/standard-workbench.umilayout",
        "framework/resources/windows/umicom-application.rc.in",
    };
    static const char *const required_module_files[] = {
        "applications/desktop/CMakeLists.txt",
        "applications/desktop/application.umicom.yaml",
        "applications/desktop/resources/layouts/mosaic.umilayout",
        "applications/studio/CMakeLists.txt",
        "applications/studio/application.umicom.yaml",
        "applications/os/CMakeLists.txt",
        "applications/os/application.umicom.yaml",
        "applications/os/resources/layouts/system.umilayout",
    };
    static const char *const framework_application_runtime_files[] = {
        "framework/cmake/UmicomApplicationRuntimeIntegration.cmake",
        "framework/include/umicom/application/runtime_catalogue.h",
        "framework/include/umicom/application/launcher.h",
        "framework/include/umicom/desktop/application_strip.h",
        "framework/include/umicom/desktop/desk_runtime.h",
        "framework/include/umicom/ui/gtk4/desk.h",
        "framework/resources/application-runtime-defaults.json",
        "framework/resources/schemas/application-runtime.schema.json",
    };
    size_t index;
    int success = 1;

    success &= require_condition(
        UMICOM_FRAMEWORK_ABI_VERSION > 0U,
        "Framework publishes a non-zero stable ABI version");
    success &= require_condition(
        path_is_file("framework/CMakeLists.txt"),
        "Framework submodule contains CMakeLists.txt");
    success &= require_condition(
        path_is_file("applications/studio/CMakeLists.txt"),
        "Studio application module contains CMakeLists.txt");
    success &= require_condition(
        path_is_file("applications/studio/application.umicom.yaml"),
        "Studio application module contains its application manifest");
    success &= require_condition(
        path_is_file("manifests/applications.json"),
        "Composition catalogue exists");
    success &= require_condition(
        path_is_file("manifests/resources.json"),
        "Resource ownership manifest exists");
    success &= require_condition(
        file_contains("manifests/applications.json", "umicom.applications/3"),
        "Application catalogue uses schema version 3");
    success &= require_condition(
        file_contains("manifests/applications.json", "org.umicom.desktop"),
        "Umicom Desktop module is recorded in the application catalogue");
    success &= require_condition(
        file_contains("manifests/applications.json", "org.umicom.os"),
        "Umicom OS module is recorded without owning the Linux kernel");
    success &= require_condition(
        path_is_file("manifests/desk-runtime.json"),
        "Desk runtime policy exists");
    success &= require_condition(
        file_contains("manifests/desk-runtime.json",
                      "\"scan_arbitrary_directories\": false"),
        "Desk runtime prohibits arbitrary directory execution");
    success &= require_condition(
        file_contains("manifests/desk-runtime.json",
                      "\"kernel_inside_framework\": false"),
        "Linux kernel remains outside Framework");

    for (index = 0U;
         index < sizeof(module_directories) / sizeof(module_directories[0]);
         ++index) {
        success &= require_condition(
            path_is_directory(module_directories[index]),
            module_directories[index]);
    }
    for (index = 0U;
         index < sizeof(repository_names) / sizeof(repository_names[0]);
         ++index) {
        success &= require_condition(
            file_contains("manifests/applications.json", repository_names[index]),
            repository_names[index]);
    }
    for (index = 0U;
         index < sizeof(architecture_decisions) /
                     sizeof(architecture_decisions[0]);
         ++index) {
        success &= require_condition(
            path_is_file(architecture_decisions[index]),
            architecture_decisions[index]);
    }

    for (index = 0U;
         index < sizeof(framework_resource_files) /
                     sizeof(framework_resource_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(framework_resource_files[index]),
            framework_resource_files[index]);
    }

    for (index = 0U;
         index < sizeof(required_module_files) /
                     sizeof(required_module_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(required_module_files[index]),
            required_module_files[index]);
    }

    for (index = 0U;
         index < sizeof(framework_application_runtime_files) /
                     sizeof(framework_application_runtime_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(framework_application_runtime_files[index]),
            framework_application_runtime_files[index]);
    }

    (void)printf("Umicom Framework public version: %s; ABI: %u\n",
                 UMICOM_FRAMEWORK_VERSION_STRING,
                 (unsigned int)UMICOM_FRAMEWORK_ABI_VERSION);
    return success ? 0 : 1;
}
