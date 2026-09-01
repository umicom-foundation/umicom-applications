/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_productisation_portfolio.c
 *
 * PURPOSE:
 *   Verify every checked-in application module contributes executable,
 *   tested and surface-complete adoption evidence to Umicom Framework.
 *
 * AUTHOR AND ORGANISATION:
 * Sammy Hegab
 * Umicom Foundation
 *
 * LICENCE:
 * MIT
 *---------------------------------------------------------------------------*/
#include <stdlib.h>
#include <string.h>

#include "umicom/application/experience_catalogue.h"
#include "umicom/application/productisation/adoption_registry.h"
#include "umicom/application/productisation/launch_guidance.h"
#include "umicom/application/productisation/surface_projection.h"
#include "umicom/application/portfolio.h"
#include "umicom/application/presentation.h"
#include "umicom/accountant/productisation_contribution.h"
#include "umicom/ai_creator/productisation_contribution.h"
#include "umicom/bank/productisation_contribution.h"
#include "umicom/cad/productisation_contribution.h"
#include "umicom/database_studio/productisation_contribution.h"
#include "umicom/desktop_module/productisation_contribution.h"
#include "umicom/education/productisation_contribution.h"
#include "umicom/exchange/productisation_contribution.h"
#include "umicom/games/productisation_contribution.h"
#include "umicom/integration_studio/productisation_contribution.h"
#include "umicom/kitchen/productisation_contribution.h"
#include "umicom/llm/productisation_contribution.h"
#include "umicom/marketplace/productisation_contribution.h"
#include "umicom/media/productisation_contribution.h"
#include "umicom/mobile_studio/productisation_contribution.h"
#include "umicom/music/productisation_contribution.h"
#include "umicom/operations/productisation_contribution.h"
#include "umicom/os_module/productisation_contribution.h"
#include "umicom/rag/productisation_contribution.h"
#include "umicom/security_centre/productisation_contribution.h"
#include "umicom/studio/productisation_contribution.h"
#include "umicom/tms/productisation_contribution.h"
#include "umicom/trader/productisation_contribution.h"
#include "umicom/web_studio/productisation_contribution.h"
#include "umicom/test_runtime/check.h"

typedef UmiStatus (*UmiApplicationProductSessionInitialiser)(
    UmiProductApplicationSession *out_session);

/* Register one thin contribution in the existing application runtime catalogue. */
static UmiStatus register_runtime_contribution(
    UmiApplicationRuntimeCatalogue *catalogue,
    const UmiProductApplicationAdoption *adoption)
{
    const UmiApplicationDefinition *definition;
    const UmiApplicationPresentation *presentation;
    UmiApplicationRuntimeRegistration registration = {0};

    /* The test uses public suite metadata and rejects incomplete contributions. */
    if (catalogue == NULL || adoption == NULL) {
        return UMI_STATUS_INVALID_ARGUMENT;
    }

    definition = umi_application_portfolio_find(adoption->application_id);
    presentation = umi_application_presentation_find(adoption->application_id);
    /* Every contributed application must retain canonical Framework metadata. */
    if (definition == NULL || presentation == NULL) {
        return UMI_STATUS_NOT_FOUND;
    }

    registration.structure_size = (uint32_t)sizeof(registration);
    registration.application_id = adoption->application_id;
    registration.display_name = adoption->display_name;
    registration.executable_name = adoption->executable_id;
    registration.working_directory = "";
    registration.icon_resource_id = presentation->icon_resource_id;
    registration.default_layout_id = presentation->default_layout_id;
    registration.taskbar_group = presentation->taskbar_group;
    registration.family = definition->family;
    registration.maturity = definition->maturity;
    registration.entry_kind = presentation->entry_kind;
    registration.installed = adoption->executable_available != 0;
    registration.compatible = true;
    registration.enabled = true;
    registration.pinned = presentation->pinned_by_default;
    registration.visible_when_unavailable =
        presentation->visible_when_unavailable;
    return umi_application_runtime_catalogue_register(
        catalogue, &registration);
}

/* Prove all independently versioned application contributions compose together. */
int main(void)
{
    const UmiProductApplicationAdoption *contributions[] = {
        umi_accountant_productisation_contribution(),
        umi_bank_productisation_contribution(),
        umi_cad_productisation_contribution(),
        umi_ai_creator_productisation_contribution(),
        umi_database_studio_productisation_contribution(),
        umi_desktop_module_productisation_contribution(),
        umi_education_productisation_contribution(),
        umi_exchange_productisation_contribution(),
        umi_games_productisation_contribution(),
        umi_integration_studio_productisation_contribution(),
        umi_kitchen_productisation_contribution(),
        umi_llm_productisation_contribution(),
        umi_marketplace_productisation_contribution(),
        umi_media_productisation_contribution(),
        umi_mobile_studio_productisation_contribution(),
        umi_music_productisation_contribution(),
        umi_operations_productisation_contribution(),
        umi_os_module_productisation_contribution(),
        umi_rag_productisation_contribution(),
        umi_security_centre_productisation_contribution(),
        umi_studio_productisation_contribution(),
        umi_tms_productisation_contribution(),
        umi_trader_productisation_contribution(),
        umi_web_studio_productisation_contribution()
    };
    const UmiApplicationProductSessionInitialiser session_initialisers[] = {
        umi_accountant_product_session_init,
        umi_bank_product_session_init,
        umi_cad_product_session_init,
        umi_ai_creator_product_session_init,
        umi_database_studio_product_session_init,
        umi_desktop_module_product_session_init,
        umi_education_product_session_init,
        umi_exchange_product_session_init,
        umi_games_product_session_init,
        umi_integration_studio_product_session_init,
        umi_kitchen_product_session_init,
        umi_llm_product_session_init,
        umi_marketplace_product_session_init,
        umi_media_product_session_init,
        umi_mobile_studio_product_session_init,
        umi_music_product_session_init,
        umi_operations_product_session_init,
        umi_os_module_product_session_init,
        umi_rag_product_session_init,
        umi_security_centre_product_session_init,
        umi_studio_product_session_init,
        umi_tms_product_session_init,
        umi_trader_product_session_init,
        umi_web_studio_product_session_init
    };
    UmiProductAdoptionRegistry registry;
    UmiProductAdoptionRegistryReport report;
    UmiProductSurfacePortfolio *surfaces =
        (UmiProductSurfacePortfolio *)calloc(1U, sizeof(*surfaces));
    UmiProductWorkspaceGuidePortfolio *workspace_guides =
        (UmiProductWorkspaceGuidePortfolio *)calloc(
            1U, sizeof(*workspace_guides));
    UmiApplicationRuntimeCatalogue *runtime_catalogue = NULL;
    UmiApplicationLaunchSelection *launch_selection = NULL;
    UmiProductGuidedLaunchPlan *guided_launch =
        (UmiProductGuidedLaunchPlan *)calloc(1U, sizeof(*guided_launch));
    UmiProductApplicationSession *session =
        (UmiProductApplicationSession *)calloc(1U, sizeof(*session));
    UmiProductApplicationSessionSnapshot *session_snapshot =
        (UmiProductApplicationSessionSnapshot *)calloc(
            1U, sizeof(*session_snapshot));
    const UmiProductGuidedLaunchEntry *guided_entry;
    size_t expected_surface_count = 0U;
    size_t index;

    /* Portfolio values contain storage for every application and therefore
     * belong on checked heap memory rather than the native test stack. */
    UMI_TEST_REQUIRE(surfaces != NULL && workspace_guides != NULL &&
                     guided_launch != NULL && session != NULL &&
                     session_snapshot != NULL);
    UMI_TEST_REQUIRE(sizeof(contributions) / sizeof(contributions[0]) ==
                     sizeof(session_initialisers) /
                         sizeof(session_initialisers[0]));
    umi_product_adoption_registry_init(&registry);
    for (index = 0U;
         index < sizeof(contributions) / sizeof(contributions[0]);
         ++index) {
        UMI_TEST_REQUIRE(contributions[index] != NULL);
        UMI_TEST_REQUIRE(umi_product_adoption_registry_register(
            &registry, contributions[index]) == UMI_STATUS_OK);
        UMI_TEST_REQUIRE(session_initialisers[index](session) ==
                         UMI_STATUS_OK);
        UMI_TEST_REQUIRE(umi_product_application_session_snapshot(
            session, session_snapshot) == UMI_STATUS_OK);
        UMI_TEST_REQUIRE(strcmp(session_snapshot->application_id,
                                contributions[index]->application_id) == 0);
        UMI_TEST_REQUIRE(session_snapshot->workspace.layout_id[0] != '\0');
        UMI_TEST_REQUIRE(
            session_snapshot->workspace.active_panel_count > 0U);
        UMI_TEST_REQUIRE(session_snapshot->runnable);
        UMI_TEST_REQUIRE(session_snapshot->acceptance_ready);
    }
    UMI_TEST_REQUIRE(registry.count ==
                     sizeof(contributions) / sizeof(contributions[0]));
    UMI_TEST_REQUIRE(umi_product_adoption_registry_report(
        &registry, &report) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(report.contribution_count == registry.count);
    UMI_TEST_REQUIRE(report.canonical_count == registry.count);
    UMI_TEST_REQUIRE(report.runnable_count == registry.count);
    UMI_TEST_REQUIRE(report.tested_count == registry.count);
    UMI_TEST_REQUIRE(report.layout_ready_count == registry.count);
    UMI_TEST_REQUIRE(report.surface_complete_count == registry.count);
    UMI_TEST_REQUIRE(report.accepted_count == registry.count);
    UMI_TEST_REQUIRE(report.invalid_count == 0U);

    /* Build one compact guide index for the suite launcher composition root. */
    UMI_TEST_REQUIRE(umi_product_workspace_guide_portfolio_build(
        &registry, workspace_guides) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(workspace_guides->application_count == registry.count);
    UMI_TEST_REQUIRE(workspace_guides->acceptance_ready_count ==
                     registry.count);

    UMI_TEST_REQUIRE(umi_application_runtime_catalogue_create(
        &runtime_catalogue) == UMI_STATUS_OK);
    /* Register every application from its contribution and canonical metadata. */
    for (index = 0U;
         index < sizeof(contributions) / sizeof(contributions[0]);
         ++index) {
        UMI_TEST_REQUIRE(register_runtime_contribution(
            runtime_catalogue, contributions[index]) == UMI_STATUS_OK);
    }

    /* A running Trader must be activated while a stopped Studio is started. */
    UMI_TEST_REQUIRE(umi_application_runtime_catalogue_set_process(
        runtime_catalogue, "org.umicom.trader", 101U) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(umi_application_launch_selection_create(
        runtime_catalogue, &launch_selection) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(umi_application_launch_selection_set_selected(
        launch_selection, "org.umicom.studio", true) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(umi_application_launch_selection_set_selected(
        launch_selection, "org.umicom.trader", true) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(umi_product_guided_launch_plan_build(
        launch_selection, workspace_guides, guided_launch) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(guided_launch->entry_count + 1U == registry.count);
    UMI_TEST_REQUIRE(guided_launch->selected_count == 2U);
    UMI_TEST_REQUIRE(guided_launch->ready_to_execute_count == 2U);
    UMI_TEST_REQUIRE(guided_launch->start_count == 1U);
    UMI_TEST_REQUIRE(guided_launch->activate_count == 1U);
    UMI_TEST_REQUIRE(guided_launch->missing_guidance_count == 0U);
    UMI_TEST_REQUIRE(guided_launch->guidance_warning_count == 0U);
    UMI_TEST_REQUIRE(guided_launch->executable);
    guided_entry = umi_product_guided_launch_plan_find(
        guided_launch, "org.umicom.studio");
    UMI_TEST_REQUIRE(guided_entry != NULL);
    UMI_TEST_REQUIRE(guided_entry->guidance_state ==
                     UMI_PRODUCT_LAUNCH_GUIDANCE_READY_TO_START);
    guided_entry = umi_product_guided_launch_plan_find(
        guided_launch, "org.umicom.trader");
    UMI_TEST_REQUIRE(guided_entry != NULL);
    UMI_TEST_REQUIRE(guided_entry->guidance_state ==
                     UMI_PRODUCT_LAUNCH_GUIDANCE_READY_TO_ACTIVATE);

    UMI_TEST_REQUIRE(umi_product_surface_portfolio_build(surfaces) ==
                     UMI_STATUS_OK);
    /* The suite surface total is the sum of canonical panels. Deriving this
     * value keeps the acceptance test accurate when a real panel is added. */
    for (index = 0U;
         index < umi_application_experience_catalogue_count();
         ++index) {
        const UmiApplicationExperienceDefinition *experience =
            umi_application_experience_catalogue_at(index);
        UMI_TEST_REQUIRE(experience != NULL);
        expected_surface_count += experience->panel_count;
    }
    UMI_TEST_REQUIRE(surfaces->application_count ==
                     umi_application_experience_catalogue_count());
    UMI_TEST_REQUIRE(surfaces->surface_count == expected_surface_count);
    UMI_TEST_REQUIRE(surfaces->covered_count == surfaces->surface_count);
    UMI_TEST_REQUIRE(surfaces->missing_count == 0U);
    free(surfaces);
    umi_application_launch_selection_destroy(launch_selection);
    umi_application_runtime_catalogue_destroy(runtime_catalogue);
    free(session_snapshot);
    free(session);
    free(guided_launch);
    free(workspace_guides);
    return 0;
}
