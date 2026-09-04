#-----------------------------------------------------------------------------
# Umicom Applications
# File: cmake/UmicomProductGovernanceAudit.cmake
#
# PURPOSE:
#   Validate canonical product documentation, decision identity, terminology
#   and coverage of every application registered by the suite repository.
#
# AUTHOR AND ORGANISATION:
#   Sammy Hegab
#   Umicom Foundation
#
# LICENCE:
#   MIT
#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.24)

if(NOT DEFINED UMICOM_GOVERNANCE_ROOT OR
   UMICOM_GOVERNANCE_ROOT STREQUAL "")
    message(FATAL_ERROR
        "UMICOM_GOVERNANCE_ROOT is required")
endif()

cmake_path(
    ABSOLUTE_PATH UMICOM_GOVERNANCE_ROOT
    NORMALIZE
    OUTPUT_VARIABLE _umicom_root)

set(_umicom_required_documents
    "docs/governance/PRODUCT_DESIGN_AND_ARCHITECTURE_GOVERNANCE.md"
    "docs/governance/PRODUCT_DECISION_REGISTER.md"
    "docs/governance/APPLICATION_FEATURE_COVERAGE.md"
    "docs/governance/DECISION_RECORD_TEMPLATE.md"
    "docs/governance/REPOSITORY_ARCHITECTURE_AUDIT.md"
    "docs/architecture/UNIVERSAL_APPLICATION_WORKBENCH.md"
    "docs/architecture/FRAMEWORK_APPLICATION_ADOPTION.md"
    "docs/architecture/WORKBENCH_FEATURE_ROADMAP.md")

# Fail with the repository-relative path so the correction can be made without
# reverse engineering a generated or machine-specific absolute path.
foreach(_umicom_document IN LISTS _umicom_required_documents)
    if(NOT EXISTS "${_umicom_root}/${_umicom_document}")
        message(FATAL_ERROR
            "Required canonical document is missing: ${_umicom_document}")
    endif()
endforeach()

set(_umicom_governance_document
    "${_umicom_root}/docs/governance/PRODUCT_DESIGN_AND_ARCHITECTURE_GOVERNANCE.md")
set(_umicom_decision_document
    "${_umicom_root}/docs/governance/PRODUCT_DECISION_REGISTER.md")
set(_umicom_coverage_document
    "${_umicom_root}/docs/governance/APPLICATION_FEATURE_COVERAGE.md")
set(_umicom_workbench_document
    "${_umicom_root}/docs/architecture/UNIVERSAL_APPLICATION_WORKBENCH.md")
set(_umicom_adoption_document
    "${_umicom_root}/docs/architecture/FRAMEWORK_APPLICATION_ADOPTION.md")
set(_umicom_roadmap_document
    "${_umicom_root}/docs/architecture/WORKBENCH_FEATURE_ROADMAP.md")

file(READ "${_umicom_governance_document}" _umicom_governance_text)
file(READ "${_umicom_decision_document}" _umicom_decision_text)
file(READ "${_umicom_coverage_document}" _umicom_coverage_text)
file(READ "${_umicom_workbench_document}" _umicom_workbench_text)
file(READ "${_umicom_adoption_document}" _umicom_adoption_text)
file(READ "${_umicom_roadmap_document}" _umicom_roadmap_text)

# Check a durable semantic marker rather than whitespace or formatting details.
function(_umicom_require_text document_text required_text description)
    string(FIND "${document_text}" "${required_text}" _umicom_text_position)
    if(_umicom_text_position EQUAL -1)
        message(FATAL_ERROR
            "${description} is missing required text: ${required_text}")
    endif()
endfunction()

_umicom_require_text(
    "${_umicom_governance_text}"
    "Umicom Framework is the single source of truth"
    "Product governance")
_umicom_require_text(
    "${_umicom_governance_text}"
    "Mandatory documentation protocol"
    "Product governance")
_umicom_require_text(
    "${_umicom_decision_text}"
    "ARCH-001"
    "Product decision register")
_umicom_require_text(
    "${_umicom_decision_text}"
    "Every registered application is in scope"
    "Product decision register")
_umicom_require_text(
    "${_umicom_workbench_text}"
    "Application-surface tabs"
    "Universal application workbench")
_umicom_require_text(
    "${_umicom_workbench_text}"
    "Edit Layout mode"
    "Universal application workbench")
_umicom_require_text(
    "${_umicom_adoption_text}"
    "Prohibited application-local mechanisms"
    "Framework application adoption")
_umicom_require_text(
    "${_umicom_roadmap_text}"
    "Functional vertical journeys"
    "Workbench feature roadmap")

# Decision identifiers remain stable. Duplicates would make implementation,
# supersession and acceptance evidence ambiguous.
file(STRINGS "${_umicom_decision_document}"
    _umicom_decision_lines
    REGEX "^### [A-Z][A-Z0-9_-]*-[0-9][0-9][0-9] ")

set(_umicom_decision_ids)
foreach(_umicom_decision_line IN LISTS _umicom_decision_lines)
    string(REGEX MATCH
        "^### ([A-Z][A-Z0-9_-]*-[0-9][0-9][0-9]) "
        _umicom_decision_match
        "${_umicom_decision_line}")
    set(_umicom_decision_id "${CMAKE_MATCH_1}")
    if(_umicom_decision_id STREQUAL "")
        message(FATAL_ERROR
            "Unable to read decision identifier from: ${_umicom_decision_line}")
    endif()
    list(FIND _umicom_decision_ids
        "${_umicom_decision_id}"
        _umicom_existing_decision)
    if(NOT _umicom_existing_decision EQUAL -1)
        message(FATAL_ERROR
            "Duplicate product decision identifier: ${_umicom_decision_id}")
    endif()
    list(APPEND _umicom_decision_ids "${_umicom_decision_id}")
endforeach()

list(LENGTH _umicom_decision_ids _umicom_decision_count)
if(_umicom_decision_count EQUAL 0)
    message(FATAL_ERROR
        "The Product Decision Register contains no stable decision identifiers")
endif()

# The suite repository already defines application membership in .gitmodules.
# Reusing that source prevents another manually maintained application catalogue.
set(_umicom_gitmodules "${_umicom_root}/.gitmodules")
if(NOT EXISTS "${_umicom_gitmodules}")
    message(FATAL_ERROR
        "The suite .gitmodules file is required for application coverage")
endif()

file(STRINGS "${_umicom_gitmodules}"
    _umicom_application_path_lines
    REGEX "^[ \t]*path[ \t]*=[ \t]*applications/")

set(_umicom_application_paths)
foreach(_umicom_path_line IN LISTS _umicom_application_path_lines)
    string(REGEX REPLACE
        "^[ \t]*path[ \t]*=[ \t]*"
        ""
        _umicom_application_path
        "${_umicom_path_line}")
    string(STRIP "${_umicom_application_path}" _umicom_application_path)
    list(APPEND _umicom_application_paths "${_umicom_application_path}")
endforeach()
list(REMOVE_DUPLICATES _umicom_application_paths)
list(LENGTH _umicom_application_paths _umicom_application_count)

if(_umicom_application_count EQUAL 0)
    message(FATAL_ERROR
        "No applications were discovered in the suite .gitmodules file")
endif()

foreach(_umicom_application_path IN LISTS _umicom_application_paths)
    if(NOT EXISTS
       "${_umicom_root}/${_umicom_application_path}/CMakeLists.txt")
        message(FATAL_ERROR
            "Registered application is not initialised or lacks CMakeLists.txt: "
            "${_umicom_application_path}")
    endif()
    string(FIND
        "${_umicom_coverage_text}"
        "${_umicom_application_path}"
        _umicom_coverage_position)
    if(_umicom_coverage_position EQUAL -1)
        message(FATAL_ERROR
            "Application coverage is missing registered path: "
            "${_umicom_application_path}")
    endif()
endforeach()

# Canonical filenames describe durable features. Git history provides revision
# identity, so numbered delivery, phase or version-copy names are rejected.
foreach(_umicom_document IN LISTS _umicom_required_documents)
    get_filename_component(
        _umicom_document_name
        "${_umicom_document}"
        NAME)
    string(TOLOWER
        "${_umicom_document_name}"
        _umicom_document_name_lower)
    if(_umicom_document_name_lower MATCHES
       "(^|[-_])(batch|phase|ux)[-_]?[0-9]" OR
       _umicom_document_name_lower MATCHES
       "(^|[-_])v[0-9]" OR
       _umicom_document_name_lower MATCHES
       "version[-_ ]?[0-9]")
        message(FATAL_ERROR
            "Canonical document filename is delivery- or version-numbered: "
            "${_umicom_document}")
    endif()
endforeach()

# Product documentation translates research into original Umicom terminology.
# The list is intentionally checked only against the canonical files governed
# here, allowing separate legal and adapter references where they are required.
set(_umicom_prohibited_product_terms
    "Visual Studio"
    "Interactive Brokers"
    "IBKR"
    "Trader Workstation"
    "TWS"
    "RAD Studio"
    "TradingView"
    "IntelliJ"
    "NinjaTrader"
    "MetaTrader"
    "LM Studio"
    "FreeBSD"
    "Calypso")

foreach(_umicom_document IN LISTS _umicom_required_documents)
    file(READ "${_umicom_root}/${_umicom_document}" _umicom_document_text)
    string(TOLOWER "${_umicom_document_text}" _umicom_document_text_lower)
    foreach(_umicom_term IN LISTS _umicom_prohibited_product_terms)
        string(TOLOWER "${_umicom_term}" _umicom_term_lower)
        string(FIND
            "${_umicom_document_text_lower}"
            "${_umicom_term_lower}"
            _umicom_term_position)
        if(NOT _umicom_term_position EQUAL -1)
            message(FATAL_ERROR
                "Canonical Umicom documentation contains prohibited external "
                "product terminology '${_umicom_term}' in ${_umicom_document}")
        endif()
    endforeach()
endforeach()

message(
    "Umicom product governance validated: "
    "${_umicom_decision_count} decisions, "
    "${_umicom_application_count} registered applications, "
    "${_umicom_required_documents} canonical document set")
