/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_cmake_graph_closure.c
 *
 * PURPOSE:
 *   Prevent duplicate root test-source composition and the resulting CMake
 *   binary-directory collision before any test executable can be built.
 *
 * Created by: Sammy Hegab
 * Organisation: Umicom Foundation
 * Licence: MIT
 *---------------------------------------------------------------------------*/
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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
    while (fgets(buffer, (int)sizeof(buffer), stream) != NULL) {
        const char *cursor = buffer;
        while ((cursor = strstr(cursor, needle)) != NULL) {
            matches++;
            cursor += strlen(needle);
        }
    }
    assert(fclose(stream) == 0);
    assert(matches == 1U);
    return EXIT_SUCCESS;
}
