#-----------------------------------------------------------------------------
# Umicom Applications
# File: cmake/UmicomProductGovernance.cmake
#
# PURPOSE:
#   Enforce the source-controlled product-design, application-architecture and
#   complete application-coverage rules used by the Umicom application family.
#
# AUTHOR AND ORGANISATION:
#   Sammy Hegab
#   Umicom Foundation
#
# LICENCE:
#   MIT
#-----------------------------------------------------------------------------
include_guard(GLOBAL)

option(UMICOM_ENFORCE_PRODUCT_GOVERNANCE
       "Validate canonical product decisions and application coverage"
       ON)

set(UMICOM_PRODUCT_GOVERNANCE_ROOT
    "${CMAKE_SOURCE_DIR}"
    CACHE PATH
    "Root of the Umicom applications composition being validated")

set(_umicom_product_governance_audit
    "${CMAKE_CURRENT_LIST_DIR}/UmicomProductGovernanceAudit.cmake")

# Run the audit during configuration so an incomplete decision or application
# coverage update cannot silently become the generated build baseline.
if(UMICOM_ENFORCE_PRODUCT_GOVERNANCE)
    execute_process(
        COMMAND
            "${CMAKE_COMMAND}"
            "-DUMICOM_GOVERNANCE_ROOT=${UMICOM_PRODUCT_GOVERNANCE_ROOT}"
            -P "${_umicom_product_governance_audit}"
        RESULT_VARIABLE _umicom_product_governance_result
        OUTPUT_VARIABLE _umicom_product_governance_output
        ERROR_VARIABLE _umicom_product_governance_error)

    # Preserve both output streams so a contributor receives the exact
    # missing document, decision or application path.
    if(NOT _umicom_product_governance_result EQUAL 0)
        message(FATAL_ERROR
            "Umicom product governance validation failed.\n"
            "${_umicom_product_governance_output}"
            "${_umicom_product_governance_error}")
    endif()

    string(STRIP "${_umicom_product_governance_output}"
        _umicom_product_governance_output)
    if(NOT _umicom_product_governance_output STREQUAL "")
        message(STATUS "${_umicom_product_governance_output}")
    endif()

    # Give developers and automation one explicit target that can be executed
    # without rebuilding application binaries.
    if(NOT TARGET umicom-product-governance)
        add_custom_target(umicom-product-governance
            COMMAND
                "${CMAKE_COMMAND}"
                "-DUMICOM_GOVERNANCE_ROOT=${UMICOM_PRODUCT_GOVERNANCE_ROOT}"
                -P "${_umicom_product_governance_audit}"
            COMMENT
                "Validating Umicom product design and application architecture"
            VERBATIM)
    endif()

    # CTest repeats the configure-time protection and records the result in the
    # normal validation evidence generated for the complete application estate.
    if(BUILD_TESTING)
        add_test(
            NAME platform.product_governance
            COMMAND
                "${CMAKE_COMMAND}"
                "-DUMICOM_GOVERNANCE_ROOT=${UMICOM_PRODUCT_GOVERNANCE_ROOT}"
                -P "${_umicom_product_governance_audit}")
        set_tests_properties(
            platform.product_governance
            PROPERTIES LABELS
                "platform;governance;architecture;applications")
    endif()
endif()
