/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_application_composition.c
 *
 * PURPOSE:
 *   Verify the Framework/Studio composition baseline and the repository
 *   catalogue used by the runnable multi-application superproject.
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
                     const char *relative_path) {
  const int written = snprintf(destination,
                               capacity,
                               "%s/%s",
                               UMICOM_APPLICATIONS_SOURCE_DIR,
                               relative_path);
  return written >= 0 && (size_t)written < capacity;
}

static int path_is_file(const char *relative_path) {
  char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
  struct stat information;

  if (!make_path(path, sizeof(path), relative_path)) {
    return 0;
  }
  if (stat(path, &information) != 0) {
    return 0;
  }
  return S_ISREG(information.st_mode) != 0;
}

static int path_is_directory(const char *relative_path) {
  char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
  struct stat information;

  if (!make_path(path, sizeof(path), relative_path)) {
    return 0;
  }
  if (stat(path, &information) != 0) {
    return 0;
  }
  return S_ISDIR(information.st_mode) != 0;
}

static int file_contains(const char *relative_path, const char *expected_text) {
  char path[UMICOM_APPLICATIONS_PATH_CAPACITY];
  char line[2048];
  FILE *stream;

  if (!make_path(path, sizeof(path), relative_path)) {
    return 0;
  }

  stream = fopen(path, "r");
  if (stream == NULL) {
    return 0;
  }

  while (fgets(line, (int)sizeof(line), stream) != NULL) {
    if (strstr(line, expected_text) != NULL) {
      (void)fclose(stream);
      return 1;
    }
  }

  (void)fclose(stream);
  return 0;
}

static int require_condition(int condition, const char *message) {
  if (!condition) {
    (void)fprintf(stderr, "[FAIL] %s\n", message);
    return 0;
  }
  (void)printf("[PASS] %s\n", message);
  return 1;
}

int main(void) {
  static const char *const module_directories[] = {
      "applications/studio",
      "applications/trader",
      "applications/tms",
      "applications/llm",
      "applications/bank",
      "applications/exchange",
  };
  static const char *const repository_names[] = {
      "umicom-foundation/umicom-framework",
      "umicom-foundation/umicom-studio-ide-module",
      "umicom-foundation/umicom-trader-module",
      "umicom-foundation/umicom-tms-module",
      "umicom-foundation/umicom-llm-module",
      "umicom-foundation/umicom-bank-module",
      "umicom-foundation/umicom-exchange-module",
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

  (void)printf("Umicom Framework public version: %s; ABI: %u\n",
               UMICOM_FRAMEWORK_VERSION_STRING,
               (unsigned int)UMICOM_FRAMEWORK_ABI_VERSION);

  return success ? 0 : 1;
}
