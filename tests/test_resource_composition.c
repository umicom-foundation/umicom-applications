/*-----------------------------------------------------------------------------
 * Umicom Applications
 * File: tests/test_resource_composition.c
 *
 * PURPOSE:
 *   Verify Framework-owned logical resources, portable layout templates and
 *   application presentation metadata can be resolved without hard-coded
 *   application repository paths.
 *
 * AUTHOR AND ORGANISATION:
 *   Sammy Hegab
 *   Umicom Foundation
 *
 * LICENCE:
 *   MIT
 *---------------------------------------------------------------------------*/
#include "umicom/application/application.h"

#include <stdio.h>
#include <string.h>

#ifndef UMICOM_APPLICATIONS_RESOURCE_ROOT
#error "UMICOM_APPLICATIONS_RESOURCE_ROOT must identify Framework resources"
#endif

#ifndef UMICOM_APPLICATIONS_SHARED_BRAND_REQUIRED
#define UMICOM_APPLICATIONS_SHARED_BRAND_REQUIRED 0
#endif

/*
 * Exercise require condition and return a clear result when the behaviour no longer
 * matches its contract.
 */
static int require_condition(int condition, const char *message)
{
    /* Apply this branch only when its contract condition is satisfied. */
    if (!condition) {
        (void)fprintf(stderr, "[FAIL] %s\n", message);
        return 0;
    }
    (void)printf("[PASS] %s\n", message);
    return 1;
}

/*
 * Exercise resolve available and return a clear result when the behaviour no longer
 * matches its contract.
 */
static int resolve_available(const char *resource_id,
                             UmiApplicationResourceKind expected_kind)
{
    UmiApplicationResourceLocation location;
    /* Apply this branch only when its contract condition is satisfied. */
    if (umi_application_resource_resolve(
            UMICOM_APPLICATIONS_RESOURCE_ROOT,
            resource_id,
            &location) != UMI_STATUS_OK)
        return 0;
    return location.kind == expected_kind && location.available;
}

/*
 * Start this command or application, report setup failures, and return a process exit code
 * to the operating system.
 */
int main(void)
{
    UmiApplicationResourceLocation icon;
    const UmiApplicationPresentation *studio;
    const UmiApplicationPresentation *trader;
    int success = 1;

    success &= require_condition(
        umi_application_resource_catalogue_validate() == UMI_STATUS_OK,
        "Framework resource catalogue validates");
    success &= require_condition(
        umi_application_resource_catalogue_count() >= 25U,
        "Framework publishes the shared resource and icon catalogue");
    success &= require_condition(
        umi_application_presentation_catalogue_validate() == UMI_STATUS_OK,
        "Application presentation catalogue validates");

    success &= require_condition(
        umi_application_resource_resolve(
            UMICOM_APPLICATIONS_RESOURCE_ROOT,
            "umicom.icon.application.studio",
            &icon) == UMI_STATUS_OK &&
        icon.available &&
        icon.kind == UMI_APPLICATION_RESOURCE_THEME_ICON &&
        strcmp(icon.locator, "applications-development-symbolic") == 0,
        "Studio icon resolves through a logical theme-icon resource");

    success &= require_condition(
        resolve_available("umicom.theme.dark.tokens",
                          UMI_APPLICATION_RESOURCE_THEME_TOKENS),
        "Dark theme tokens resolve from Framework resources");
    success &= require_condition(
        resolve_available("umicom.layout.blank",
                          UMI_APPLICATION_RESOURCE_LAYOUT_TEMPLATE),
        "Blank semantic layout template resolves");
    success &= require_condition(
        resolve_available("umicom.layout.mosaic",
                          UMI_APPLICATION_RESOURCE_LAYOUT_TEMPLATE),
        "Mosaic semantic layout template resolves");
    success &= require_condition(
        resolve_available("umicom.layout.standard-workbench",
                          UMI_APPLICATION_RESOURCE_LAYOUT_TEMPLATE),
        "Standard Workbench semantic layout template resolves");
    success &= require_condition(
        resolve_available("umicom.windows.application-resource-template",
                          UMI_APPLICATION_RESOURCE_WINDOWS_TEMPLATE),
        "Product-neutral Windows resource template resolves");

    /* Apply this branch only when its contract condition is satisfied. */
    if (UMICOM_APPLICATIONS_SHARED_BRAND_REQUIRED != 0) {
        success &= require_condition(
            resolve_available("umicom.brand.logo.primary",
                              UMI_APPLICATION_RESOURCE_FILE),
            "Common Umicom SVG logo exists in Framework");
        success &= require_condition(
            resolve_available("umicom.brand.icon.primary",
                              UMI_APPLICATION_RESOURCE_FILE),
            "Common Umicom SVG icon exists in Framework");
#ifdef _WIN32
        /* Windows Explorer and the taskbar require a derived ICO container;
         * other frontends consume the canonical vectors directly. */
        success &= require_condition(
            resolve_available("umicom.brand.icon.windows",
                              UMI_APPLICATION_RESOURCE_FILE),
            "Common Umicom Windows icon exists in Framework");
#endif
    }

    studio = umi_application_presentation_find("org.umicom.studio");
    trader = umi_application_presentation_find("org.umicom.trader");
    success &= require_condition(
        studio != NULL && studio->pinned_by_default &&
        strcmp(studio->default_layout_id, "develop") == 0,
        "Studio contributes a pinned taskbar presentation");
    success &= require_condition(
        trader != NULL && !trader->pinned_by_default &&
        strcmp(trader->default_layout_id, "trading") == 0,
        "Trader contributes presentation metadata without becoming available");

    return success ? 0 : 1;
}
