/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_cmake_graph_closure.c
 *
 * PURPOSE:
 *   Prevent duplicate root test-source composition and the resulting CMake
 *   binary-directory collision before any test executable can be built.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------*/
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/*
 * Start this command or application, report setup failures, and return a process exit code
 * to the operating system.
 */
int main(void)
{
    const char *needle = "add_subdirectory(tests)";
    char path[1024];
    char buffer[4096];
    size_t matches = 0U;
    FILE *stream;

    (void)snprintf(path, sizeof(path), "%s/CMakeLists.txt",
                   UMICOM_APPLICATIONS_SOURCE_DIR);
    stream = fopen(path, "rb");
    assert(stream != NULL);
    /*
     * Continue only while work remains available; the loop body advances the state on each
     * pass.
     */
    while (fgets(buffer, (int)sizeof(buffer), stream) != NULL) {
        const char *cursor = buffer;
        /*
         * Continue only while work remains available; the loop body advances the state on each
         * pass.
         */
        while ((cursor = strstr(cursor, needle)) != NULL) {
            matches++;
            cursor += strlen(needle);
        }
    }
    assert(fclose(stream) == 0);
    assert(matches == 1U);
    return EXIT_SUCCESS;
}
