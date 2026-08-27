/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_validation_target_closure.c
 * PURPOSE: Prevent CTest registration from outrunning executable build closure.
 * Created by: Sammy Hegab
 * Organisation: Umicom Foundation
 * Licence: MIT
 *---------------------------------------------------------------------------*/
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static char *read_file(const char *relative_path)
{
    char path[1024];
    FILE *stream;
    long size;
    char *text;
    assert(snprintf(path, sizeof(path), "%s/%s", UMICOM_APPLICATIONS_SOURCE_DIR,
                    relative_path) > 0);
    stream = fopen(path, "rb");
    assert(stream != NULL);
    assert(fseek(stream, 0L, SEEK_END) == 0);
    size = ftell(stream);
    assert(size >= 0L);
    assert(fseek(stream, 0L, SEEK_SET) == 0);
    text = (char *)malloc((size_t)size + 1U);
    assert(text != NULL);
    assert(fread(text, 1U, (size_t)size, stream) == (size_t)size);
    text[size] = '\0';
    assert(fclose(stream) == 0);
    return text;
}

static void require_text(const char *text, const char *expected)
{
    assert(strstr(text, expected) != NULL);
}

int main(void)
{
    char *root = read_file("CMakeLists.txt");
    char *workstation = read_file(
        "framework/cmake/UmicomGtk4WorkstationPlatform.cmake");
    char *experience = read_file(
        "applications/studio/cmake/UmicomStudioExperienceIntegration.cmake");
    char *studio = read_file("applications/studio/CMakeLists.txt");
    require_text(root, "umicom_assert_single_root_test_tree");
    require_text(root, "umicom-registered-validation-tests ALL");
    require_text(workstation,
        "umicom_register_validation_target(\"${target}\")");
    require_text(experience,
        "umicom_register_validation_target(umicom-studio-experience-centre-test)");
    require_text(studio,
        "umicom-studio-editor-intelligence-workbench-contribution-test)");
    require_text(studio, "umicom-studio-vcs-workbench-contribution-test)");
    require_text(studio, "umicom-studio-data-workbench-contribution-test)");
    require_text(studio, "umicom-studio-web-api-workbench-contribution-test)");
    free(studio);
    free(experience);
    free(workstation);
    free(root);
    return 0;
}
