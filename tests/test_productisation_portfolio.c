/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_productisation_portfolio.c
 *
 * PURPOSE:
 *   Verify every checked-in application module contributes executable,
 *   tested and surface-complete adoption evidence to Umicom Framework.
 *
 * Created by: Sammy Hegab
 * Organisation: Umicom Foundation
 * Licence: MIT
 *---------------------------------------------------------------------------*/
#include <assert.h>

#include "umicom/application/productisation/adoption_registry.h"
#include "umicom/application/productisation/surface_projection.h"
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
    UmiProductAdoptionRegistry registry;
    UmiProductAdoptionRegistryReport report;
    UmiProductSurfacePortfolio surfaces;
    size_t index;

    umi_product_adoption_registry_init(&registry);
    for (index = 0U;
         index < sizeof(contributions) / sizeof(contributions[0]);
         ++index) {
        assert(contributions[index] != NULL);
        assert(umi_product_adoption_registry_register(
            &registry, contributions[index]) == UMI_STATUS_OK);
    }
    assert(registry.count == 24U);
    assert(umi_product_adoption_registry_report(
        &registry, &report) == UMI_STATUS_OK);
    assert(report.contribution_count == 24U);
    assert(report.canonical_count == 24U);
    assert(report.runnable_count == 24U);
    assert(report.tested_count == 24U);
    assert(report.layout_ready_count == 24U);
    assert(report.surface_complete_count == 24U);
    assert(report.accepted_count == 24U);
    assert(report.invalid_count == 0U);

    assert(umi_product_surface_portfolio_build(&surfaces) == UMI_STATUS_OK);
    assert(surfaces.application_count == 25U);
    assert(surfaces.surface_count == 263U);
    assert(surfaces.covered_count == 263U);
    assert(surfaces.missing_count == 0U);
    return 0;
}
