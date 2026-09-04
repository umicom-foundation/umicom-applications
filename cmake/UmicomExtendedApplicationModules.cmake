#-----------------------------------------------------------------------------
# Umicom Applications
# File: cmake/UmicomExtendedApplicationModules.cmake
#
# PURPOSE:
#   Register the extended thin application module estate without duplicating
#   Framework implementation in the suite root.
#
# AUTHOR AND ORGANISATION:
#   Sammy Hegab
#   Umicom Foundation
#
# LICENCE:
#   MIT
#-----------------------------------------------------------------------------

option(UMICOM_APPLICATIONS_BUILD_MUSIC_STUDIO
       "Build the Umicom Music Studio application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_MEDIA_STUDIO
       "Build the Umicom Media Studio application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_ACCOUNTANT
       "Build the Umicom Accountant application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_RAG
       "Build the Umicom RAG application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_GAMES
       "Build the Umicom Games application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_AI_CREATOR
       "Build the Umicom AI Creator application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_KITCHEN_DESIGNER
       "Build the Umicom Kitchen Designer application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_CAD
       "Build the Umicom CAD application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_WEB_STUDIO
       "Build the Umicom Web Studio application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_MOBILE_STUDIO
       "Build the Umicom Mobile Studio application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_DATABASE_STUDIO
       "Build the Umicom Database Studio application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_INTEGRATION_STUDIO
       "Build the Umicom Integration Studio application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_OPERATIONS
       "Build the Umicom Operations application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_SECURITY_CENTRE
       "Build the Umicom Security Centre application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_MARKETPLACE
       "Build the Umicom Marketplace application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_EDUCATION
       "Build the Umicom Education Studio application module"
       OFF)

option(UMICOM_APPLICATIONS_BUILD_ALL_MODULES
       "Build every checked-in Umicom application module"
       OFF)

# Create this optional product surface only when its build option is enabled.
if(UMICOM_APPLICATIONS_BUILD_ALL_MODULES)
    set(UMICOM_APPLICATIONS_BUILD_DESKTOP ON CACHE BOOL
        "Build Umicom Desk" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_STUDIO ON CACHE BOOL
        "Build Umicom Studio IDE" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_TRADER ON CACHE BOOL
        "Build Umicom Trader" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_TMS ON CACHE BOOL
        "Build Umicom TMS" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_LLM ON CACHE BOOL
        "Build Umicom LLM" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_BANK ON CACHE BOOL
        "Build Umicom Bank" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_EXCHANGE ON CACHE BOOL
        "Build Umicom Exchange" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_OS ON CACHE BOOL
        "Build Umicom OS Control Centre" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_MUSIC_STUDIO ON CACHE BOOL
        "Build Umicom Music Studio" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_MEDIA_STUDIO ON CACHE BOOL
        "Build Umicom Media Studio" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_ACCOUNTANT ON CACHE BOOL
        "Build Umicom Accountant" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_RAG ON CACHE BOOL
        "Build Umicom RAG" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_GAMES ON CACHE BOOL
        "Build Umicom Games" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_AI_CREATOR ON CACHE BOOL
        "Build Umicom AI Creator" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_KITCHEN_DESIGNER ON CACHE BOOL
        "Build Umicom Kitchen Designer" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_CAD ON CACHE BOOL
        "Build Umicom CAD" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_WEB_STUDIO ON CACHE BOOL
        "Build Umicom Web Studio" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_MOBILE_STUDIO ON CACHE BOOL
        "Build Umicom Mobile Studio" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_DATABASE_STUDIO ON CACHE BOOL
        "Build Umicom Database Studio" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_INTEGRATION_STUDIO ON CACHE BOOL
        "Build Umicom Integration Studio" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_OPERATIONS ON CACHE BOOL
        "Build Umicom Operations" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_SECURITY_CENTRE ON CACHE BOOL
        "Build Umicom Security Centre" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_MARKETPLACE ON CACHE BOOL
        "Build Umicom Marketplace" FORCE)
    set(UMICOM_APPLICATIONS_BUILD_EDUCATION ON CACHE BOOL
        "Build Umicom Education Studio" FORCE)
endif()

# Define the add extended application modules build helper so parent and application
# projects apply one consistent rule.
function(umicom_add_extended_application_modules)
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_MUSIC_STUDIO
        "applications/music"
        "Umicom Music Studio")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_MEDIA_STUDIO
        "applications/media"
        "Umicom Media Studio")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_ACCOUNTANT
        "applications/accountant"
        "Umicom Accountant")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_RAG
        "applications/rag"
        "Umicom RAG")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_GAMES
        "applications/games"
        "Umicom Games")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_AI_CREATOR
        "applications/creator"
        "Umicom AI Creator")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_KITCHEN_DESIGNER
        "applications/kitchen"
        "Umicom Kitchen Designer")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_CAD
        "applications/cad"
        "Umicom CAD")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_WEB_STUDIO
        "applications/web-studio"
        "Umicom Web Studio")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_MOBILE_STUDIO
        "applications/mobile-studio"
        "Umicom Mobile Studio")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_DATABASE_STUDIO
        "applications/database-studio"
        "Umicom Database Studio")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_INTEGRATION_STUDIO
        "applications/integration-studio"
        "Umicom Integration Studio")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_OPERATIONS
        "applications/operations"
        "Umicom Operations")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_SECURITY_CENTRE
        "applications/security-centre"
        "Umicom Security Centre")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_MARKETPLACE
        "applications/marketplace"
        "Umicom Marketplace")
    umicom_add_optional_application(
        UMICOM_APPLICATIONS_BUILD_EDUCATION
        "applications/education"
        "Umicom Education Studio")
endfunction()

# Product and architecture decisions are part of the suite contract. The shared
# audit is included here because this catalogue is already loaded by every
# suite configuration and therefore cannot be bypassed by disabling one product.
include("${CMAKE_CURRENT_LIST_DIR}/UmicomProductGovernance.cmake")
