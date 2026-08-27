#-----------------------------------------------------------------------------
# Umicom Applications
# File: tests/CMakeLists.txt
#
# PURPOSE:
#   Validate the runnable composition root, pinned module catalogue, Framework
#   resource ownership and public application/taskbar contracts.
#
# AUTHOR AND ORGANISATION:
#   Sammy Hegab
#   Umicom Foundation
#
# LICENCE:
#   MIT
#-----------------------------------------------------------------------------
add_executable(umicom-applications-composition-test
    test_application_composition.c
)

target_link_libraries(umicom-applications-composition-test PRIVATE
    Umicom::base
)

target_compile_definitions(umicom-applications-composition-test PRIVATE
    UMICOM_APPLICATIONS_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
)

umicom_apply_warnings(umicom-applications-composition-test)
umicom_apply_sanitizers(umicom-applications-composition-test)

add_test(
    NAME applications.composition
    COMMAND umicom-applications-composition-test
)

add_executable(umicom-applications-resource-composition-test
    test_resource_composition.c
)

target_link_libraries(umicom-applications-resource-composition-test PRIVATE
    Umicom::application
)

target_compile_definitions(umicom-applications-resource-composition-test PRIVATE
    UMICOM_APPLICATIONS_SOURCE_DIR="${CMAKE_SOURCE_DIR}"
    UMICOM_APPLICATIONS_RESOURCE_ROOT="${UMICOM_FRAMEWORK_RESOURCE_ROOT}"
    UMICOM_APPLICATIONS_SHARED_BRAND_REQUIRED=$<BOOL:${UMICOM_STUDIO_BUILD_GTK}>
)
umicom_apply_warnings(umicom-applications-resource-composition-test)
umicom_apply_sanitizers(umicom-applications-resource-composition-test)
add_test(
    NAME applications.resources
    COMMAND umicom-applications-resource-composition-test
)

add_executable(umicom-applications-desk-runtime-test
    test_desk_runtime_composition.c
)
target_link_libraries(umicom-applications-desk-runtime-test PRIVATE
    Umicom::Framework
)
umicom_apply_warnings(umicom-applications-desk-runtime-test)
umicom_apply_sanitizers(umicom-applications-desk-runtime-test)
add_test(
    NAME applications.desk_runtime
    COMMAND umicom-applications-desk-runtime-test
)
add_executable(umicom-applications-workbench-layout-test
    test_workbench_layout_composition.c
)

target_link_libraries(umicom-applications-workbench-layout-test PRIVATE
    Umicom::workbench_layout
)

umicom_apply_warnings(umicom-applications-workbench-layout-test)
umicom_apply_sanitizers(umicom-applications-workbench-layout-test)

add_test(
    NAME applications.workbench_layout
    COMMAND umicom-applications-workbench-layout-test
)

if(UMICOM_APPLICATIONS_BUILD_ALL_MODULES)
    set(UMICOM_PRODUCTISATION_CONTRIBUTION_TARGETS
        umicom_accountant_productisation
        umicom_bank_productisation
        umicom_cad_productisation
        umicom_ai_creator_productisation
        umicom_database_studio_productisation
        umicom_desktop_productisation
        umicom_education_productisation
        umicom_exchange_productisation
        umicom_games_productisation
        umicom_integration_studio_productisation
        umicom_kitchen_productisation
        umicom_llm_productisation
        umicom_marketplace_productisation
        umicom_media_productisation
        umicom_mobile_studio_productisation
        umicom_music_productisation
        umicom_operations_productisation
        umicom_os_productisation
        umicom_rag_productisation
        umicom_security_centre_productisation
        umicom_studio_productisation
        umicom_tms_productisation
        umicom_trader_productisation
        umicom_web_studio_productisation)
    foreach(UMICOM_PRODUCTISATION_CONTRIBUTION_TARGET
            IN LISTS UMICOM_PRODUCTISATION_CONTRIBUTION_TARGETS)
        if(NOT TARGET "${UMICOM_PRODUCTISATION_CONTRIBUTION_TARGET}")
            message(FATAL_ERROR
                "Missing all-module productisation target '${UMICOM_PRODUCTISATION_CONTRIBUTION_TARGET}'")
        endif()
    endforeach()

    add_executable(umicom-applications-productisation-portfolio-test
        test_productisation_portfolio.c)
    target_link_libraries(umicom-applications-productisation-portfolio-test
        PRIVATE
            Umicom::application
            ${UMICOM_PRODUCTISATION_CONTRIBUTION_TARGETS})
    umicom_apply_warnings(umicom-applications-productisation-portfolio-test)
    umicom_apply_sanitizers(umicom-applications-productisation-portfolio-test)
    add_test(
        NAME applications.productisation.portfolio
        COMMAND umicom-applications-productisation-portfolio-test)
    set_tests_properties(
        applications.productisation.portfolio
        PROPERTIES LABELS "applications;productisation;portfolio;acceptance")
    if(COMMAND umicom_register_validation_target)
        umicom_register_validation_target(
            umicom-applications-productisation-portfolio-test)
    endif()
endif()
