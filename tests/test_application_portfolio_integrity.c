/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_application_portfolio_integrity.c
 *
 * PURPOSE:
 *   Verify that every configured application submodule has one unique product
 *   identity and executable, agrees with the root catalogue, and that thin
 *   applications expose the shared Framework runtime closure.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------*/

#include <stdio.h>
#include <string.h>

#ifndef UMICOM_APPLICATIONS_SOURCE_DIR
#error "UMICOM_APPLICATIONS_SOURCE_DIR must identify the composition root"
#endif

#define UMI_PATH_CAPACITY 1024U

typedef struct UmiExpectedApplication {
    const char *directory;
    const char *application_id;
    const char *repository;
    const char *executable;
} UmiExpectedApplication;

typedef struct UmiExpectedThinRuntime {
    const char *directory;
    const char *include_namespace;
} UmiExpectedThinRuntime;

static const UmiExpectedApplication APPLICATIONS[] = {
    {"accountant", "org.umicom.accountant", "umicom-accountant-module", "umicom-accountant-console"},
    {"bank", "org.umicom.bank", "umicom-bank-module", "umicom-bank-console"},
    {"cad", "org.umicom.cad", "umicom-cad-module", "umicom-cad-console"},
    {"creator", "org.umicom.creator", "umicom-ai-creator-module", "umicom-ai-creator-console"},
    {"database-studio", "org.umicom.database-studio", "umicom-database-studio-module", "umicom-database-studio-console"},
    {"desktop", "org.umicom.desktop", "umicom-desktop-module", "umicom-desk"},
    {"education", "org.umicom.education", "umicom-education-studio-module", "umicom-education-console"},
    {"exchange", "org.umicom.exchange", "umicom-exchange-module", "umicom-exchange-console"},
    {"games", "org.umicom.games", "umicom-games-module", "umicom-games-console"},
    {"integration-studio", "org.umicom.integration-studio", "umicom-integration-studio-module", "umicom-integration-studio-console"},
    {"kitchen", "org.umicom.kitchen-designer", "umicom-kitchen-designer-module", "umicom-kitchen-designer-console"},
    {"llm", "org.umicom.llm", "umicom-llm-module", "umicom-llm-console"},
    {"marketplace", "org.umicom.marketplace", "umicom-marketplace-module", "umicom-marketplace-console"},
    {"media", "org.umicom.media-studio", "umicom-media-studio-module", "umicom-media-studio-console"},
    {"mobile-studio", "org.umicom.mobile-studio", "umicom-mobile-studio-module", "umicom-mobile-studio-console"},
    {"music", "org.umicom.music-studio", "umicom-music-studio-module", "umicom-music-studio-console"},
    {"operations", "org.umicom.operations", "umicom-operations-module", "umicom-operations-console"},
    {"os", "org.umicom.os", "umicom-os-module", "umicom-os-control-centre"},
    {"rag", "org.umicom.rag", "umicom-rag-module", "umicom-rag-console"},
    {"security-centre", "org.umicom.security-centre", "umicom-security-centre-module", "umicom-security-centre-console"},
    {"studio", "org.umicom.studio", "umicom-studio-ide-module", "umicom-studio-ide"},
    {"tms", "org.umicom.tms", "umicom-tms-module", "umicom-tms-console"},
    {"trader", "org.umicom.trader", "umicom-trader-module", "umicom-trader-console"},
    {"web-studio", "org.umicom.web-studio", "umicom-web-studio-module", "umicom-web-studio-console"},
};

static const UmiExpectedThinRuntime THIN_RUNTIMES[] = {
    {"accountant", "accountant"},
    {"cad", "cad"},
    {"database-studio", "database_studio"},
    {"education", "education"},
    {"exchange", "exchange"},
    {"games", "games"},
    {"integration-studio", "integration_studio"},
    {"kitchen", "kitchen_designer"},
    {"llm", "llm"},
    {"marketplace", "marketplace"},
    {"media", "media_studio"},
    {"mobile-studio", "mobile_studio"},
    {"music", "music_studio"},
    {"operations", "operations"},
    {"rag", "rag"},
    {"security-centre", "security_centre"},
    {"web-studio", "web_studio"},
};

static int make_path(char *destination, size_t capacity, const char *relative)
{
    const int written = snprintf(destination, capacity, "%s/%s",
                                 UMICOM_APPLICATIONS_SOURCE_DIR, relative);
    return written >= 0 && (size_t)written < capacity;
}

static int file_contains(const char *relative, const char *text)
{
    char path[UMI_PATH_CAPACITY];
    char line[4096];
    FILE *stream;
    if (!make_path(path, sizeof(path), relative)) return 0;
    stream = fopen(path, "r");
    if (stream == NULL) return 0;
    while (fgets(line, (int)sizeof(line), stream) != NULL) {
        if (strstr(line, text) != NULL) {
            (void)fclose(stream);
            return 1;
        }
    }
    (void)fclose(stream);
    return 0;
}

static size_t file_occurrence_count(const char *relative, const char *text)
{
    char path[UMI_PATH_CAPACITY];
    char line[4096];
    size_t count = 0U;
    FILE *stream;
    if (!make_path(path, sizeof(path), relative)) return 0U;
    stream = fopen(path, "r");
    if (stream == NULL) return 0U;
    while (fgets(line, (int)sizeof(line), stream) != NULL) {
        const char *cursor = line;
        while ((cursor = strstr(cursor, text)) != NULL) {
            ++count;
            cursor += strlen(text);
        }
    }
    (void)fclose(stream);
    return count;
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
    size_t index;
    size_t other;
    int success = 1;

    success &= require_condition(
        sizeof(APPLICATIONS) / sizeof(APPLICATIONS[0]) == 24U,
        "portfolio declares exactly 24 application submodules");
    success &= require_condition(
        file_occurrence_count("manifests/applications.json", "\"id\": \"org.umicom.") == 24U,
        "root catalogue contains exactly 24 application identities");
    success &= require_condition(
        !file_contains("manifests/applications.json", "planned_modules"),
        "root catalogue has no stale or duplicate planned-module collection");

    for (index = 0U; index < sizeof(APPLICATIONS) / sizeof(APPLICATIONS[0]);
         ++index) {
        char manifest_path[UMI_PATH_CAPACITY];
        char root_path[UMI_PATH_CAPACITY];
        char git_path[UMI_PATH_CAPACITY];
        char git_url[UMI_PATH_CAPACITY];
        const UmiExpectedApplication *application = &APPLICATIONS[index];
        (void)snprintf(manifest_path, sizeof(manifest_path),
                       "applications/%s/application.umicom.yaml",
                       application->directory);
        (void)snprintf(root_path, sizeof(root_path),
                       "\"path\": \"applications/%s\"",
                       application->directory);
        (void)snprintf(git_path, sizeof(git_path),
                       "path = applications/%s", application->directory);
        (void)snprintf(git_url, sizeof(git_url),
                       "umicom-foundation/%s.git", application->repository);

        success &= require_condition(
            file_contains(manifest_path, application->application_id),
            application->application_id);
        success &= require_condition(
            file_contains(manifest_path, application->executable),
            application->executable);
        success &= require_condition(
            file_contains("manifests/applications.json", root_path), root_path);
        success &= require_condition(
            file_contains("manifests/applications.json", application->repository),
            application->repository);
        success &= require_condition(
            file_contains("manifests/applications.json", application->executable),
            application->executable);
        success &= require_condition(file_contains(".gitmodules", git_path), git_path);
        success &= require_condition(file_contains(".gitmodules", git_url), git_url);

        for (other = index + 1U;
             other < sizeof(APPLICATIONS) / sizeof(APPLICATIONS[0]); ++other) {
            success &= require_condition(
                strcmp(application->application_id,
                       APPLICATIONS[other].application_id) != 0,
                "application identities remain unique");
            success &= require_condition(
                strcmp(application->executable,
                       APPLICATIONS[other].executable) != 0,
                "application executables remain unique");
        }
    }

    for (index = 0U;
         index < sizeof(THIN_RUNTIMES) / sizeof(THIN_RUNTIMES[0]); ++index) {
        static const char *const runtime_files[] = {
            "runtime.h", "readiness.h", "workspace_commands.h"};
        size_t file_index;
        char cmake_path[UMI_PATH_CAPACITY];
        (void)snprintf(cmake_path, sizeof(cmake_path),
                       "applications/%s/CMakeLists.txt",
                       THIN_RUNTIMES[index].directory);
        success &= require_condition(
            file_contains(cmake_path, "UmicomThinApplicationRuntime.cmake"),
            cmake_path);
        for (file_index = 0U;
             file_index < sizeof(runtime_files) / sizeof(runtime_files[0]);
             ++file_index) {
            char header_path[UMI_PATH_CAPACITY];
            (void)snprintf(header_path, sizeof(header_path),
                           "applications/%s/include/umicom/%s/%s",
                           THIN_RUNTIMES[index].directory,
                           THIN_RUNTIMES[index].include_namespace,
                           runtime_files[file_index]);
            success &= require_condition(file_contains(header_path, "UmiStatus"),
                                         header_path);
        }
    }

    return success ? 0 : 1;
}
