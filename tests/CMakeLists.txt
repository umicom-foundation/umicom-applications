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
