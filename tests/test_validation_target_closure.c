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
    free(studio);
    free(experience);
    free(workstation);
    free(root);
    return 0;
}
