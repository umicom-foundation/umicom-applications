/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_validation_target_closure.c
 * PURPOSE:
 *   Prevent CTest registration from outrunning executable build closure.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------*/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "umicom/test_runtime/check.h"

/*
 * Exercise read file and return a clear result when the behaviour no longer matches its
 * contract.
 */
static char *read_file(const char *relative_path)
{
    char path[1024];
    FILE *stream;
    long size;
    char *text;
    if (snprintf(path, sizeof(path), "%s/%s", UMICOM_APPLICATIONS_SOURCE_DIR,
                 relative_path) <= 0)
        return NULL;
    stream = fopen(path, "rb");
    if (stream == NULL)
        return NULL;
    if (fseek(stream, 0L, SEEK_END) != 0) {
        (void)fclose(stream);
        return NULL;
    }
    size = ftell(stream);
    if (size < 0L || fseek(stream, 0L, SEEK_SET) != 0) {
        (void)fclose(stream);
        return NULL;
    }
    text = (char *)malloc((size_t)size + 1U);
    if (text == NULL) {
        (void)fclose(stream);
        return NULL;
    }
    if (fread(text, 1U, (size_t)size, stream) != (size_t)size) {
        free(text);
        (void)fclose(stream);
        return NULL;
    }
    text[size] = '\0';
    if (fclose(stream) != 0) {
        free(text);
        return NULL;
    }
    return text;
}

/*
 * Exercise require text and return a clear result when the behaviour no longer matches its
 * contract.
 */
static int require_text(const char *text, const char *expected)
{
    return text != NULL && expected != NULL && strstr(text, expected) != NULL;
}

/* Keep the focused recovery build explicit and independent of product links. */
static int require_native_workbench_closure(const char *root)
{
    static const char *const expected_targets[] = {
        "umicom-application-manifest-tests",
        "umicom-applications-native-manifest-test",
        "umicom-ui-workstation-maximize-mode-test",
        "umicom-application-native-discovery-test",
        "umicom-platform-executable-path-test",
        "umicom-workspace-library-test",
        "umicom-ui-workspace-checkpoint-test",
        "umicom-ui-workspace-library-checkpoint-test",
        "umicom-applications-validation-target-closure-test",
        "umicom-gtk4-workspace-maximise-test",
        "umicom-gtk4-suite-navigation-test",
        "umicom-gtk4-command-bar-lifetime-test",
        "umicom-gtk4-desk-home-test",
        "umicom-gtk4-layout-library-test",
        "umicom-gtk4-workspace-canvas-test",
        "umicom-gtk4-workspace-checkpoint-test",
        "umicom-gtk4-workspace-content-test",
        "umicom-desktop-window-titlebar-test",
        "umicom-studio-workspace-canvas-test"
    };
    char *focused = read_file("cmake/UmicomNativeWorkbenchValidation.cmake");
    size_t index;
    int valid = focused != NULL && require_text(root,
        "include(\"${CMAKE_CURRENT_SOURCE_DIR}/cmake/UmicomNativeWorkbenchValidation.cmake\")");
    for (index = 0U; valid && index < sizeof(expected_targets) / sizeof(expected_targets[0]); ++index)
        valid = require_text(focused, expected_targets[index]);
    valid = valid && require_text(focused,
        "add_custom_target(umicom-native-workbench-regression-tests") &&
        !require_text(focused, "add_custom_target(umicom-native-workbench-regression-tests ALL") &&
        require_text(focused, "umicom_assert_native_workbench_test_closure(${_umicom_native_workbench_targets})") &&
        require_text(focused, "MANUALLY_ADDED_DEPENDENCIES") &&
        require_text(focused, "LINK_LIBRARIES INTERFACE_LINK_LIBRARIES") &&
        require_text(focused, "Native coverage is incomplete in this configuration.") &&
        require_text(focused, "CTest has not run.") &&
        require_text(focused, "if(NOT BUILD_TESTING)") &&
        require_text(focused, "message(FATAL_ERROR");
    free(focused);
    return valid;
}

/*
 * Start this command or application, report setup failures, and return a process exit code
 * to the operating system.
 */
int main(void)
{
    char *root = read_file("CMakeLists.txt");
    char *workstation = read_file(
        "framework/cmake/UmicomGtk4WorkstationPlatform.cmake");
    char *experience = read_file(
        "applications/studio/cmake/UmicomStudioExperienceIntegration.cmake");
    char *studio = read_file("applications/studio/CMakeLists.txt");
    UMI_TEST_REQUIRE(root != NULL && workstation != NULL &&
                     experience != NULL && studio != NULL);
    UMI_TEST_REQUIRE(require_text(root, "umicom_assert_single_root_test_tree"));
    /* The aggregate is intentionally opt-in, so it is not marked ALL and
     * cannot unexpectedly rebuild every validation executable. */
    UMI_TEST_REQUIRE(require_text(root,
                                  "add_custom_target(umicom-registered-validation-tests)"));
    UMI_TEST_REQUIRE(require_text(workstation,
        "umicom_register_validation_target(\"${target}\")"));
    UMI_TEST_REQUIRE(require_text(experience,
        "umicom_register_validation_target(umicom-studio-experience-centre-test)"));
    UMI_TEST_REQUIRE(require_text(studio,
        "umicom-studio-editor-intelligence-workbench-contribution-test)"));
    UMI_TEST_REQUIRE(require_text(studio, "umicom-studio-vcs-workbench-contribution-test)"));
    UMI_TEST_REQUIRE(require_text(studio, "umicom-studio-data-workbench-contribution-test)"));
    UMI_TEST_REQUIRE(require_text(studio, "umicom-studio-web-api-workbench-contribution-test)"));
    UMI_TEST_REQUIRE(require_native_workbench_closure(root));
    free(studio);
    free(experience);
    free(workstation);
    free(root);
    return 0;
}
