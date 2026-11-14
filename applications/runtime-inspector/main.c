/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: applications/runtime-inspector/main.c
 * PURPOSE:
 *   Present dependency names from one selected Windows executable or library.
 * EDUCATIONAL OVERVIEW:
 *   The Framework owns byte validation. This thin host reads a bounded file,
 *   closes it, then prints the immutable result without loading any DLL.
 * AUTHOR AND ORGANISATION:
 *   Sammy Hegab
 *   Umicom Foundation
 * LICENCE:
 *   MIT
 *---------------------------------------------------------------------------*/
#include "umicom/education/pe_imports.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Read one complete bounded input; a failed read or close never reaches parsing. */
static UmiStatus InspectFile(const char *path, UmiEducationPeImports *result)
{
    FILE *file = fopen(path, "rb");
    if (file == NULL) return UMI_STATUS_IO_ERROR;
    if (fseek(file, 0L, SEEK_END) != 0) { (void)fclose(file); return UMI_STATUS_IO_ERROR; }
    long count = ftell(file);
    if (count < 0L || (unsigned long)count > UMI_PE_IMPORT_IMAGE_LIMIT || fseek(file, 0L, SEEK_SET) != 0) {
        (void)fclose(file); return UMI_STATUS_CAPACITY_EXCEEDED;
    }
    size_t size = (size_t)count;
    unsigned char *data = malloc(size == 0U ? 1U : size);
    if (data == NULL) { (void)fclose(file); return UMI_STATUS_OUT_OF_MEMORY; }
    size_t received = fread(data, 1U, size, file);
    int closed = fclose(file);
    UmiStatus status = received == size && closed == 0 ?
        UmiEducationPeImportsInspectBytes(data, size, result) : UMI_STATUS_IO_ERROR;
    free(data);
    return status;
}

/* No repair or execution is implicit. Dependencies are observations, not a loadability guarantee. */
int main(int argc, char **argv)
{
    if (argc == 2 && strcmp(argv[1], "--help") == 0) {
        puts("Usage: umicom-runtime-inspect <executable-or-dll>\nRead PE32/PE32+ imports without loading code.");
        return 0;
    }
    if (argc != 2) { fputs("Supply one executable or DLL path.\n", stderr); return 1; }
    UmiEducationPeImports *result = calloc(1U, sizeof(*result));
    if (result == NULL) return 6;
    UmiStatus status = InspectFile(argv[1], result);
    if (status == UMI_STATUS_OK) {
        (void)printf("{\"machine\":%u,\"address_bits\":%u,\"imports\":[",
            (unsigned)result->machine, (unsigned)result->address_bits);
        for (size_t i = 0U; i < result->count; ++i)
            (void)printf("%s\"%s\"", i == 0U ? "" : ",", result->names[i]);
        puts("]}");
    } else {
        (void)fprintf(stderr, "PE inspection failed with Framework status %d. No code was loaded.\n", (int)status);
    }
    free(result);
    return (int)status;
}
