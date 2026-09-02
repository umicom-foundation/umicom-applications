/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_application_composition.c
 *
 * PURPOSE:
 *   Verify the Framework/application composition baseline, repository
 *   catalogue, required module contracts and shared-resource ownership
 *   expected by the runnable multi-application superproject.
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

/*
 * Exercise make path and return a clear result when the behaviour no longer matches its
 * contract.
 */
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

/*
 * Exercise path is file and return a clear result when the behaviour no longer matches its
 * contract.
 */
static int path_is_file(const char *relative_path)
{
    char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
    struct stat information;
    /* Apply this branch only when its contract condition is satisfied. */
    if (!make_path(path, sizeof(path), relative_path)) return 0;
    /* Apply this branch only when its contract condition is satisfied. */
    if (stat(path, &information) != 0) return 0;
    return S_ISREG(information.st_mode) != 0;
}

/*
 * Exercise path is directory and return a clear result when the behaviour no longer
 * matches its contract.
 */
static int path_is_directory(const char *relative_path)
{
    char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
    struct stat information;
    /* Apply this branch only when its contract condition is satisfied. */
    if (!make_path(path, sizeof(path), relative_path)) return 0;
    /* Apply this branch only when its contract condition is satisfied. */
    if (stat(path, &information) != 0) return 0;
    return S_ISDIR(information.st_mode) != 0;
}

/*
 * Exercise file contains and return a clear result when the behaviour no longer matches
 * its contract.
 */
static int file_contains(const char *relative_path, const char *expected_text)
{
    char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
    char line[4096];
    FILE *stream;
    /* Apply this branch only when its contract condition is satisfied. */
    if (!make_path(path, sizeof(path), relative_path)) return 0;
    stream = fopen(path, "r");
    /*
     * Protect caller-owned memory by checking that required state is available before it is
     * used.
     */
    if (stream == NULL) return 0;
    /*
     * Continue only while work remains available; the loop body advances the state on each
     * pass.
     */
    while (fgets(line, (int)sizeof(line), stream) != NULL) {
        /*
         * Protect caller-owned memory by checking that required state is available before it is
         * used.
         */
        if (strstr(line, expected_text) != NULL) {
            (void)fclose(stream);
            return 1;
        }
    }
    (void)fclose(stream);
    return 0;
}

/*
 * Exercise require condition and return a clear result when the behaviour no longer
 * matches its contract.
 */
static int require_condition(int condition, const char *message)
{
    /* Apply this branch only when its contract condition is satisfied. */
    if (!condition) {
        (void)fprintf(stderr, "[FAIL] %s\n", message);
        return 0;
    }
    (void)printf("[PASS] %s\n", message);
    return 1;
}

/*
 * Start this command or application, report setup failures, and return a process exit code
 * to the operating system.
 */
int main(void)
{
    static const char *const module_directories[] = {
        "applications/accountant",
        "applications/bank",
        "applications/cad",
        "applications/creator",
        "applications/database-studio",
        "applications/desktop",
        "applications/education",
        "applications/exchange",
        "applications/games",
        "applications/integration-studio",
        "applications/kitchen",
        "applications/llm",
        "applications/marketplace",
        "applications/media",
        "applications/mobile-studio",
        "applications/music",
        "applications/operations",
        "applications/os",
        "applications/rag",
        "applications/security-centre",
        "applications/studio",
        "applications/tms",
        "applications/trader",
        "applications/web-studio",
    };
    static const char *const repository_names[] = {
        "umicom-foundation/umicom-framework",
        "umicom-foundation/umicom-accountant-module",
        "umicom-foundation/umicom-bank-module",
        "umicom-foundation/umicom-cad-module",
        "umicom-foundation/umicom-ai-creator-module",
        "umicom-foundation/umicom-database-studio-module",
        "umicom-foundation/umicom-desktop-module",
        "umicom-foundation/umicom-education-studio-module",
        "umicom-foundation/umicom-exchange-module",
        "umicom-foundation/umicom-games-module",
        "umicom-foundation/umicom-integration-studio-module",
        "umicom-foundation/umicom-kitchen-designer-module",
        "umicom-foundation/umicom-llm-module",
        "umicom-foundation/umicom-marketplace-module",
        "umicom-foundation/umicom-media-studio-module",
        "umicom-foundation/umicom-mobile-studio-module",
        "umicom-foundation/umicom-music-studio-module",
        "umicom-foundation/umicom-operations-module",
        "umicom-foundation/umicom-os-module",
        "umicom-foundation/umicom-rag-module",
        "umicom-foundation/umicom-security-centre-module",
        "umicom-foundation/umicom-studio-ide-module",
        "umicom-foundation/umicom-tms-module",
        "umicom-foundation/umicom-trader-module",
        "umicom-foundation/umicom-web-studio-module",
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
    static const char *const framework_workbench_layout_files[] = {
        "framework/cmake/UmicomWorkbenchLayoutPlatform.cmake",
        "framework/include/umicom/workbench_layout/workbench_layout.h",
        "framework/resources/schemas/workbench-layout.schema.json",
        "framework/resources/workbench-layout-defaults.json",
        "framework/resources/layouts/templates/blank.umilayout",
        "framework/resources/layouts/templates/development.umilayout",
        "framework/resources/layouts/templates/mosaic.umilayout",
        "framework/resources/layouts/templates/operations.umilayout",
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
        file_contains("manifests/applications.json", "umicom.applications/4"),
        "Application catalogue uses schema version 4");
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

    /* Visit each bounded item once so every record receives the same rule. */
    for (index = 0U;
         index < sizeof(module_directories) / sizeof(module_directories[0]);
         ++index) {
        success &= require_condition(
            path_is_directory(module_directories[index]),
            module_directories[index]);
    }
    /* Visit each bounded item once so every record receives the same rule. */
    for (index = 0U;
         index < sizeof(repository_names) / sizeof(repository_names[0]);
         ++index) {
        success &= require_condition(
            file_contains("manifests/applications.json", repository_names[index]),
            repository_names[index]);
    }

    /* Visit each bounded item once so every record receives the same rule. */
    for (index = 0U;
         index < sizeof(framework_resource_files) /
                     sizeof(framework_resource_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(framework_resource_files[index]),
            framework_resource_files[index]);
    }

    /* Visit each bounded item once so every record receives the same rule. */
    for (index = 0U;
         index < sizeof(required_module_files) /
                     sizeof(required_module_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(required_module_files[index]),
            required_module_files[index]);
    }

    /* Visit each bounded item once so every record receives the same rule. */
    for (index = 0U;
         index < sizeof(framework_application_runtime_files) /
                     sizeof(framework_application_runtime_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(framework_application_runtime_files[index]),
            framework_application_runtime_files[index]);
    }

    /* Visit each bounded item once so every record receives the same rule. */
    for (index = 0U;
         index < sizeof(framework_workbench_layout_files) /
                     sizeof(framework_workbench_layout_files[0]);
         ++index) {
        success &= require_condition(
            path_is_file(framework_workbench_layout_files[index]),
            framework_workbench_layout_files[index]);
    }

    (void)printf("Umicom Framework public version: %s; ABI: %u\n",
                 UMICOM_FRAMEWORK_VERSION_STRING,
                 (unsigned int)UMICOM_FRAMEWORK_ABI_VERSION);
    return success ? 0 : 1;
}
