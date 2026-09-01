/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_application_production_control_plane.c
 *
 * PURPOSE:
 *   Validate the Framework production control plane across every canonical
 *   application while keeping independently versioned products thin.
 *
 * Created by: Sammy Hegab
 * Organisation: Umicom Foundation
 * Licence: MIT
 *---------------------------------------------------------------------------*/
#include <stdlib.h>

#include "umicom/application/experience_catalogue.h"
#include "umicom/application/production/production.h"
#include "umicom/test_runtime/check.h"

static int structural_capability_probe(const char *capability_id, void *context)
{
    (void)context;
    return capability_id != NULL && capability_id[0] != '\0';
}

int main(void)
{
    UmiApplicationProductionControlPlane *control_plane =
        calloc(1U, sizeof(*control_plane));
    UmiApplicationProductionGapAudit audit;
    size_t expected_panels = 0U;
    size_t expected_layouts = 0U;
    size_t expected_features = 0U;
    size_t expected_application_features = 0U;
    size_t expected_external_features = 0U;
    size_t application_index;

    UMI_TEST_REQUIRE(control_plane != NULL);
    UMI_TEST_REQUIRE(umi_application_production_control_plane_init(
        structural_capability_probe, NULL, control_plane) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(control_plane->portfolio.count ==
                     umi_application_experience_catalogue_count());
    UMI_TEST_REQUIRE(control_plane->registry.count ==
                     umi_application_experience_catalogue_count());

    /* Calculate expected portfolio totals from the canonical experience
     * catalogue so adding a real feature never requires unrelated magic-number
     * edits in this integration test. */
    for (application_index = 0U;
         application_index < umi_application_experience_catalogue_count();
         ++application_index) {
        const UmiApplicationExperienceDefinition *experience =
            umi_application_experience_catalogue_at(application_index);
        size_t feature_index;
        UMI_TEST_REQUIRE(experience != NULL);
        expected_panels += experience->panel_count;
        expected_layouts += experience->layout_count;
        expected_features += experience->feature_count;
        for (feature_index = 0U;
             feature_index < experience->feature_count;
             ++feature_index) {
            const UmiExperienceFeatureDefinition *feature =
                &experience->features[feature_index];
            if (feature->owner == UMI_EXPERIENCE_OWNER_APPLICATION) {
                expected_application_features += 1U;
            } else if (feature->owner ==
                       UMI_EXPERIENCE_OWNER_EXTERNAL_ADAPTER) {
                expected_external_features += 1U;
            }
        }
    }
    UMI_TEST_REQUIRE(control_plane->report.panel_count == expected_panels);
    UMI_TEST_REQUIRE(control_plane->report.layout_count == expected_layouts);
    UMI_TEST_REQUIRE(control_plane->report.feature_count == expected_features);
    UMI_TEST_REQUIRE(umi_application_production_gap_audit_build(
        &control_plane->portfolio, &audit) == UMI_STATUS_OK);
    UMI_TEST_REQUIRE(audit.uncovered_panel_count == 0U);
    UMI_TEST_REQUIRE(audit.manifest_drift_count == 0U);
    UMI_TEST_REQUIRE(audit.application_feature_count ==
                     expected_application_features);
    UMI_TEST_REQUIRE(audit.external_adapter_feature_count ==
                     expected_external_features);
    free(control_plane);
    return 0;
}
