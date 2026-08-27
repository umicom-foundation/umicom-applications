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
#include <assert.h>
#include <stdlib.h>

#include "umicom/application/production/production.h"

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
    assert(control_plane != NULL);
    assert(umi_application_production_control_plane_init(
        structural_capability_probe, NULL, control_plane) == UMI_STATUS_OK);
    assert(control_plane->portfolio.count == 25U);
    assert(control_plane->registry.count == 25U);
    assert(control_plane->report.panel_count == 263U);
    assert(control_plane->report.layout_count == 62U);
    assert(control_plane->report.feature_count == 157U);
    assert(umi_application_production_gap_audit_build(
        &control_plane->portfolio, &audit) == UMI_STATUS_OK);
    assert(audit.uncovered_panel_count == 0U);
    assert(audit.manifest_drift_count == 0U);
    assert(audit.application_feature_count == 24U);
    assert(audit.external_adapter_feature_count == 12U);
    free(control_plane);
    return 0;
}

