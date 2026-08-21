/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_workbench_layout_composition.c
 *
 * PURPOSE:
 *   Verify that the integrated application superproject can create, edit and
 *   persist a Framework-owned semantic workbench layout through public APIs.
 *
 * AUTHOR AND ORGANISATION:
 *   Sammy Hegab
 *   Umicom Foundation
 *
 * LICENCE:
 *   MIT
 *---------------------------------------------------------------------------*/
#include "umicom/workbench_layout/workbench_layout.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define REQUIRE_STATUS_OK(expression)                                        \
    do {                                                                      \
        UmiStatus integration_status = (expression);                          \
        if (integration_status != UMI_STATUS_OK) {                            \
            (void)fprintf(stderr,                                             \
                          "[FAIL] status=%d for %s\n",                        \
                          (int)integration_status,                            \
                          #expression);                                       \
            return 1;                                                         \
        }                                                                     \
    } while (0)

#define REQUIRE_CONDITION(condition, message)                                \
    do {                                                                      \
        if (!(condition)) {                                                   \
            (void)fprintf(stderr, "[FAIL] %s\n", (message));                 \
            return 1;                                                         \
        }                                                                     \
    } while (0)

static int copy_text(char *destination,
                     size_t capacity,
                     const char *source)
{
    size_t length;

    if (destination == NULL || capacity == 0U || source == NULL) {
        return 0;
    }
    length = strlen(source);
    if (length >= capacity) {
        return 0;
    }
    (void)memcpy(destination, source, length + 1U);
    return 1;
}

int main(void)
{
    UmiWorkbenchMemoryStore *store =
        (UmiWorkbenchMemoryStore *)calloc(1U, sizeof(*store));
    UmiWorkbenchLayoutStoreAdapter adapter;
    UmiWorkbenchLayoutServiceConfig config =
        umi_workbench_layout_service_config_default();
    UmiWorkbenchLayoutService *service = NULL;
    UmiWorkbenchLayoutPrincipal principal;
    UmiWorkbenchLayoutIdentity identity;
    UmiWorkbenchLayoutDocument document;
    UmiWorkbenchLayoutOperation operation;
    UmiWorkbenchLayoutOperationResult operation_result;
    UmiWorkbenchLayoutPersistenceResult persistence_result;
    UmiWorkbenchLayoutServiceSnapshot snapshot;
    const UmiWorkbenchLayoutDocument *active_layout;
    int result = 1;

    REQUIRE_CONDITION(store != NULL, "Memory store allocation failed");
    umi_workbench_memory_store_init(store);
    adapter = umi_workbench_memory_store_adapter(store);

    config.seed_framework_templates = true;
    config.maintain_history = true;
    config.emit_events = true;

    (void)memset(&principal, 0, sizeof(principal));
    principal.structure_size = sizeof(principal);
    REQUIRE_CONDITION(
        copy_text(
            principal.user_id,
            sizeof(principal.user_id),
            "integration-user"),
        "Principal user identity is invalid");
    REQUIRE_CONDITION(
        copy_text(
            principal.workspace_id,
            sizeof(principal.workspace_id),
            "workspace.integration"),
        "Principal workspace identity is invalid");
    principal.role = UMI_WORKBENCH_LAYOUT_ROLE_OWNER;
    principal.trusted_workspace = true;

    (void)memset(&identity, 0, sizeof(identity));
    REQUIRE_CONDITION(
        copy_text(
            identity.layout_id,
            sizeof(identity.layout_id),
            "layout.integration"),
        "Layout identity is invalid");
    REQUIRE_CONDITION(
        copy_text(
            identity.owner_user_id,
            sizeof(identity.owner_user_id),
            principal.user_id),
        "Layout owner identity is invalid");
    REQUIRE_CONDITION(
        copy_text(
            identity.owner_application_id,
            sizeof(identity.owner_application_id),
            "org.umicom.desktop"),
        "Layout application identity is invalid");
    REQUIRE_CONDITION(
        copy_text(
            identity.workspace_id,
            sizeof(identity.workspace_id),
            principal.workspace_id),
        "Layout workspace identity is invalid");

    REQUIRE_STATUS_OK(umi_workbench_layout_service_create(
        &config, &adapter, &service));
    REQUIRE_STATUS_OK(umi_workbench_layout_service_start(service));
    REQUIRE_STATUS_OK(umi_workbench_layout_service_clone_template(
        service,
        &principal,
        "framework.development",
        &identity,
        "Integrated Development Workbench",
        &document));

    active_layout =
        umi_workbench_layout_service_active_layout(service);
    REQUIRE_CONDITION(
        active_layout != NULL,
        "Framework service did not activate the cloned layout");

    umi_workbench_layout_operation_init(
        &operation,
        UMI_WORKBENCH_LAYOUT_OPERATION_RENAME_LAYOUT,
        "operation.integration.rename");
    REQUIRE_CONDITION(
        copy_text(
            operation.actor_id,
            sizeof(operation.actor_id),
            principal.user_id),
        "Operation actor identity is invalid");
    REQUIRE_CONDITION(
        copy_text(
            operation.correlation_id,
            sizeof(operation.correlation_id),
            "correlation.integration"),
        "Operation correlation identity is invalid");
    REQUIRE_CONDITION(
        copy_text(
            operation.text_value,
            sizeof(operation.text_value),
            "Integrated Development Layout"),
        "Operation text is invalid");
    operation.expected_revision = active_layout->version.revision;
    operation.timestamp_ms = 1000U;

    REQUIRE_STATUS_OK(umi_workbench_layout_service_apply_operation(
        service,
        &principal,
        &operation,
        &operation_result));
    REQUIRE_CONDITION(
        operation_result.changed,
        "Rename operation did not change the active layout");

    REQUIRE_STATUS_OK(umi_workbench_layout_service_save(
        service,
        &principal,
        principal.user_id,
        operation.correlation_id,
        1010U,
        &persistence_result));
    REQUIRE_CONDITION(
        persistence_result.resulting_revision > 0U,
        "Persisted layout revision was not recorded");
    REQUIRE_CONDITION(
        umi_workbench_memory_store_layout_count(store) == 1U,
        "Integrated layout was not stored");

    REQUIRE_STATUS_OK(umi_workbench_layout_service_snapshot(
        service, &snapshot));
    REQUIRE_CONDITION(
        snapshot.template_count >= 4U,
        "Framework template registry was not seeded");
    REQUIRE_CONDITION(
        strcmp(snapshot.active_layout_id, identity.layout_id) == 0,
        "Service snapshot does not identify the active layout");
    REQUIRE_CONDITION(
        snapshot.active_layout_revision > 0U,
        "Service snapshot does not expose the active revision");
    REQUIRE_CONDITION(
        !snapshot.dirty,
        "Saved integrated layout must be clean");

    REQUIRE_STATUS_OK(umi_workbench_layout_service_stop(
        service, 1020U));
    result = 0;

    umi_workbench_layout_service_destroy(service);
    umi_workbench_memory_store_clear(store);
    free(store);
    return result;
}
