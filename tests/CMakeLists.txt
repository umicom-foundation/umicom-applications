#-----------------------------------------------------------------------------
# Umicom Applications
# File: tests/CMakeLists.txt
#
# PURPOSE:
#   Validate the new composition root, its pinned module catalogue and the
#   availability of the Framework public version contract.
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
