/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_desk_runtime_composition.c
 *
 * PURPOSE:
 *   Prove that the composition root can register Desktop, Studio and OS,
 *   launch through the Framework adapter boundary and preserve taskbar state.
 *
 * Created by: Sammy Hegab
 * Organisation: Umicom Foundation
 * Licence: MIT
 *---------------------------------------------------------------------------*/
#include "umicom/desktop/desk_runtime.h"

#include <stdio.h>
#include <string.h>

#define REQUIRE(condition)                                                     \
    do {                                                                       \
        if (!(condition)) {                                                    \
            (void)fprintf(stderr, "[FAIL] %s:%d: %s\n",                       \
                          __FILE__, __LINE__, #condition);                      \
            return 1;                                                          \
        }                                                                      \
    } while (0)

typedef struct FakeProcessAdapter {
    uint64_t next_token;
    size_t starts;
} FakeProcessAdapter;

static UmiStatus start_process(
    void *context,
    const UmiApplicationLaunchPlan *plan,
    uint64_t *out_process_token)
{
    FakeProcessAdapter *adapter = (FakeProcessAdapter *)context;
    REQUIRE(plan->executable_path[0] != '\0');
    adapter->starts += 1U;
    adapter->next_token += 1U;
    *out_process_token = adapter->next_token;
    return UMI_STATUS_OK;
}

static UmiApplicationRuntimeRegistration make_registration(
    const char *id,
    const char *name,
    const char *executable,
    const char *layout,
    UmiApplicationEntryKind kind)
{
    UmiApplicationRuntimeRegistration value = {0};
    value.structure_size = sizeof(value);
    value.application_id = id;
    value.display_name = name;
    value.executable_name = executable;
    value.working_directory = "";
    value.icon_resource_id = "umicom.icon.application.generic";
    value.default_layout_id = layout;
    value.taskbar_group = "applications";
    value.family = kind == UMI_APPLICATION_ENTRY_SYSTEM
        ? UMI_APPLICATION_FAMILY_PLATFORM
        : UMI_APPLICATION_FAMILY_DEVELOPMENT;
    value.maturity = UMI_APPLICATION_AVAILABLE;
    value.entry_kind = kind;
    value.installed = true;
    value.compatible = true;
    value.enabled = true;
    value.pinned = true;
    return value;
}

int main(void)
{
    UmiDeskRuntime *runtime = NULL;
    UmiDeskRuntimeConfig config = umi_desk_runtime_config_default();
    UmiApplicationLauncherAdapter launch_adapter = {0};
    UmiApplicationRuntimeRegistration desktop = make_registration(
        "org.umicom.desktop", "Umicom Desk", "umicom-desk",
        "mosaic", UMI_APPLICATION_ENTRY_SYSTEM);
    UmiApplicationRuntimeRegistration studio = make_registration(
        "org.umicom.studio", "Umicom Studio IDE",
        "umicom-studio-ide", "develop",
        UMI_APPLICATION_ENTRY_WORKBENCH);
    UmiApplicationRuntimeRegistration os = make_registration(
        "org.umicom.os", "Umicom OS Control Centre",
        "umicom-os-control-centre", "system",
        UMI_APPLICATION_ENTRY_SYSTEM);
    UmiDeskRuntimeSnapshot snapshot;
    FakeProcessAdapter adapter = {1000U, 0U};

    config.seed_framework_portfolio = false;
    config.launcher.executable_root = "C:/umicom/bin";
    config.launcher.executable_suffix = ".exe";
    launch_adapter.structure_size = sizeof(launch_adapter);
    launch_adapter.adapter_context = &adapter;
    launch_adapter.start = start_process;

    REQUIRE(umi_desk_runtime_create(
                NULL, &config, &launch_adapter, &runtime) ==
            UMI_STATUS_OK);
    REQUIRE(umi_desk_runtime_upsert_application(
                runtime, &desktop) == UMI_STATUS_OK);
    REQUIRE(umi_desk_runtime_upsert_application(
                runtime, &studio) == UMI_STATUS_OK);
    REQUIRE(umi_desk_runtime_upsert_application(
                runtime, &os) == UMI_STATUS_OK);

    REQUIRE(umi_desk_runtime_request_application(
                runtime, "org.umicom.studio",
                UMI_DESKTOP_APPLICATION_STRIP_LAUNCH_OR_ACTIVATE) ==
            UMI_STATUS_OK);
    REQUIRE(adapter.starts == 1U);
    REQUIRE(umi_desk_runtime_snapshot(runtime, &snapshot) ==
            UMI_STATUS_OK);
    REQUIRE(snapshot.strip.item_count == 3U);
    REQUIRE(snapshot.strip.running_count == 1U);
    REQUIRE(strcmp(snapshot.strip.active_application_id,
                   "org.umicom.studio") == 0);
    REQUIRE(snapshot.applications.failed_application_count == 0U);

    REQUIRE(umi_desk_runtime_reconcile_application_exit(
                runtime, "org.umicom.studio", 3,
                "simulated child failure") == UMI_STATUS_OK);
    REQUIRE(umi_desk_runtime_snapshot(runtime, &snapshot) ==
            UMI_STATUS_OK);
    REQUIRE(snapshot.applications.failed_application_count == 1U);
    REQUIRE(snapshot.strip.attention_count == 1U);

    umi_desk_runtime_destroy(runtime);
    return 0;
}
