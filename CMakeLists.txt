#-----------------------------------------------------------------------------
# Umicom Applications
# File: CMakeLists.txt
#
# PURPOSE:
#   Compose one authoritative Umicom Framework checkout with independently
#   versioned thin application modules. The
#   runnable Umicom Desk, governed application launcher and thin OS Control
#   Centre without duplicating Framework implementation.
#
# ARCHITECTURE:
#   - Framework is configured exactly once from framework/.
#   - Application modules consume public Framework targets only.
#   - Shared resources, taskbar policy, launcher state and semantic layouts
#     remain in Framework.
#   - Umicom Desk is the outer application shell and composition host.
#   - Studio is the first complete workbench hosted and launched by Desk.
#   - Placeholder application modules never block enabled products.
#   - Linux kernel, boot and recovery remain in the full umicom-os repository.
#   - Master Controller and Slave Controllers remain the canonical lifecycle
#     terminology and are implemented by Framework/application code, not here.
#
# AUTHOR AND ORGANISATION:
#   Sammy Hegab
#   Umicom Foundation
#
# LICENCE:
#   MIT
#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.24)

project(
    UmicomApplications
    VERSION 0.3.0
    DESCRIPTION "Runnable Umicom Desk composition and thin application modules"
    LANGUAGES C
)

set(CMAKE_C_STANDARD 23)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin")
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib")

option(UMICOM_ENABLE_STRICT_WARNINGS
       "Enable the established strict warning set for Framework-based code"
       ON)
option(UMICOM_ENABLE_SANITIZERS
       "Enable AddressSanitizer and UndefinedBehaviorSanitizer where supported"
       OFF)
option(UMICOM_BUILD_NATIVE_TOOL
       "Build the native Framework-owned umicom command"
       ON)

option(UMICOM_APPLICATIONS_BUILD_DESKTOP
       "Build the Umicom Desk application module"
       ON)
option(UMICOM_APPLICATIONS_BUILD_STUDIO
       "Build the Umicom Studio IDE application module"
       ON)
option(UMICOM_APPLICATIONS_BUILD_TRADER
       "Build the Umicom Trader application module"
       ON)
option(UMICOM_APPLICATIONS_BUILD_TMS
       "Build the Umicom Open TMS application module"
       ON)
option(UMICOM_APPLICATIONS_BUILD_LLM
       "Build the Umicom LLM application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_BANK
       "Build the Umicom Bank application module"
       ON)
option(UMICOM_APPLICATIONS_BUILD_EXCHANGE
       "Build the Umicom Exchange application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_OS
       "Build the user-space Umicom OS Control Centre module"
       ON)

option(UMICOM_DESKTOP_BUILD_GTK
       "Build the GTK4 Umicom Desk application"
       ON)
option(UMICOM_DESKTOP_GUI
       "Build Umicom Desk as a Windows GUI-subsystem executable"
       ON)
option(UMICOM_STUDIO_BUILD_GTK
       "Build the GTK4 Umicom Studio IDE application"
       ON)
option(UMICOM_STUDIO_GUI
       "Build Studio as a Windows GUI-subsystem executable"
       ON)
option(UMICOM_TRADER_BUILD_GTK4
       "Build the Framework-rendered GTK4 Umicom Trader workstation"
       ON)
option(UMICOM_APPLICATIONS_STAGE_FRAMEWORK_RESOURCES
       "Stage Framework-owned shared resources for compatibility with the current Studio module"
       ON)
option(UMICOM_BUILD_REGISTERED_VALIDATION_TARGETS
       "Create the legacy focused-validation aggregate for explicit use"
       OFF)

set(UMICOM_FRAMEWORK_RESOURCE_ROOT
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/resources"
    CACHE PATH
    "Source or installed root containing the Umicom Framework resource catalogue")

include(CTest)
include(GNUInstallDirs)

# The Framework and Studio module both use these functions. Defining them in
# the composition root guarantees one warning/sanitizer policy for every
# enabled application without duplicating build logic inside application repos.
function(umicom_apply_warnings target)
    # Apply this branch only when its contract condition is satisfied.
    if(NOT UMICOM_ENABLE_STRICT_WARNINGS)
        return()
    endif()

    # Select the warning options understood by the active compiler.
    if(MSVC)
        target_compile_options(${target} PRIVATE /W4)
    # Use this fallback path when the earlier condition does not apply.
    else()
        target_compile_options(${target} PRIVATE
            -Wall
            -Wextra
            -Wpedantic
            -Wconversion
            -Wshadow
        )
    endif()
endfunction()

# Define the apply sanitizers build helper so parent and application projects apply one
# consistent rule.
function(umicom_apply_sanitizers target)
    # Apply this branch only when its contract condition is satisfied.
    if(UMICOM_ENABLE_SANITIZERS AND NOT MSVC)
        target_compile_options(${target} PRIVATE
            -fsanitize=address,undefined
            -fno-omit-frame-pointer
        )
        target_link_options(${target} PRIVATE
            -fsanitize=address,undefined
        )
    endif()
endfunction()

# Focused platform tests may be declared in Framework or a thin application.
# Registering them here provides one explicit build closure and prevents CTest
# discovery from getting ahead of its executable targets.
function(umicom_register_validation_target target)
    # Load the dependency only when the parent build has not already provided its target.
    if(NOT TARGET "${target}")
        message(FATAL_ERROR
            "Cannot register missing validation target '${target}'")
    endif()
    set_property(GLOBAL APPEND PROPERTY
        UMICOM_REGISTERED_VALIDATION_TARGETS "${target}")
endfunction()

# Configure-time graph protection must run before CTest targets are generated.
# It catches a duplicated root tests tree even when no regression executable can
# be built, which is exactly the failure mode this guard is designed to prevent.
function(umicom_assert_single_root_test_tree)
    file(STRINGS "${CMAKE_CURRENT_SOURCE_DIR}/CMakeLists.txt"
        _umicom_root_test_tree_lines
        REGEX "^[ \t]*add_subdirectory\\([ \t]*tests[ \t]*\\)")
    list(LENGTH _umicom_root_test_tree_lines _umicom_root_test_tree_count)
    # Use the stable identifier comparison to choose the matching record or policy.
    if(NOT _umicom_root_test_tree_count EQUAL 1)
        message(FATAL_ERROR
            "The root test tree must be added exactly once; found "
            "${_umicom_root_test_tree_count} root test-tree calls")
    endif()
endfunction()

# Define the require cmake project build helper so parent and application projects apply
# one consistent rule.
function(umicom_require_cmake_project relative_path display_name)
    # Apply this branch only when its contract condition is satisfied.
    if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${relative_path}/CMakeLists.txt")
        message(FATAL_ERROR
            "${display_name} is enabled but ${relative_path}/CMakeLists.txt is missing. "
            "Initialise the submodule and ensure it contains application source.")
    endif()
endfunction()

# Define the require framework resource build helper so parent and application projects
# apply one consistent rule.
function(umicom_require_framework_resource relative_path logical_id)
    # Apply this branch only when its contract condition is satisfied.
    if(NOT EXISTS "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/${relative_path}")
        message(FATAL_ERROR
            "Required Framework resource '${logical_id}' is missing at "
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/${relative_path}. Copy the exact "
            "canonical asset into framework/resources before configuring.")
    endif()
endfunction()

# Define the add optional application build helper so parent and application projects
# apply one consistent rule.
function(umicom_add_optional_application option_name relative_path display_name)
    # Apply this branch only when its contract condition is satisfied.
    if(${option_name})
        # Apply this branch only when its contract condition is satisfied.
        if(ARGC GREATER 3)
            set(_umicom_application_component "${ARGV3}")
        # Use this fallback path when the earlier condition does not apply.
        else()
            string(REGEX REPLACE "[^A-Za-z0-9]" ""
                _umicom_application_component "${display_name}")
        endif()
        # Use the stable identifier comparison to choose the matching record or policy.
        if(_umicom_application_component STREQUAL "")
            message(FATAL_ERROR
                "Unable to derive an installer component for ${display_name}")
        endif()
        umicom_require_cmake_project("${relative_path}" "${display_name}")
        # Each application subdirectory inherits its own default install
        # component. Existing install rules therefore become selectable in the
        # generated installer without duplicating target lists in this file.
        set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME
            "${_umicom_application_component}")
        add_subdirectory("${relative_path}")
        set_property(GLOBAL APPEND PROPERTY UMICOM_SUITE_COMPONENT_IDS
            "${_umicom_application_component}")
        set_property(GLOBAL APPEND PROPERTY UMICOM_SUITE_COMPONENT_NAMES
            "${display_name}")
        message(STATUS "Enabled application module: ${display_name}")
    # Use this fallback path when the earlier condition does not apply.
    else()
        message(STATUS "Disabled application module: ${display_name}")
    endif()
endfunction()

# Extended application-module switches are kept in one suite-owned catalogue.
include("${CMAKE_CURRENT_SOURCE_DIR}/cmake/UmicomExtendedApplicationModules.cmake")

# -----------------------------------------------------------------------------
# Framework-owned shared resources and temporary Studio compatibility staging
# -----------------------------------------------------------------------------
# The current Studio module still reads common branding from ${CMAKE_SOURCE_DIR}
# while its standalone superproject conversion is pending. The source of truth
# is now framework/resources. CMake creates ignored compatibility copies only;
# contributors must never edit the generated root assets or generated .rc file.
if(UMICOM_APPLICATIONS_BUILD_STUDIO AND UMICOM_STUDIO_BUILD_GTK)
    umicom_require_framework_resource(
        "brand/umicom-icon.svg" "umicom.brand.icon.primary")
    umicom_require_framework_resource(
        "brand/umicom-icon-on-dark.svg" "umicom.brand.icon.on-dark")
    umicom_require_framework_resource(
        "brand/umicom-icon.png" "umicom.brand.icon.raster")
    umicom_require_framework_resource(
        "brand/umicom-logo.svg" "umicom.brand.logo.primary")
    umicom_require_framework_resource(
        "brand/umicom-logo-on-dark.svg" "umicom.brand.logo.on-dark")
    umicom_require_framework_resource(
        "brand/umicom-logo.png" "umicom.brand.logo.raster")
    umicom_require_framework_resource(
        "brand/umicom.ico" "umicom.brand.icon.windows")
    umicom_require_framework_resource(
        "windows/umicom-application.rc.in"
        "umicom.windows.application-resource-template")

    # Apply this branch only when its contract condition is satisfied.
    if(UMICOM_APPLICATIONS_STAGE_FRAMEWORK_RESOURCES)
        file(MAKE_DIRECTORY
            "${CMAKE_CURRENT_SOURCE_DIR}/assets"
            "${CMAKE_CURRENT_SOURCE_DIR}/win")

        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-icon.svg"
            "${CMAKE_CURRENT_SOURCE_DIR}/assets/umicom-icon.svg"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-icon-on-dark.svg"
            "${CMAKE_CURRENT_SOURCE_DIR}/assets/umicom-icon-on-dark.svg"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-logo.svg"
            "${CMAKE_CURRENT_SOURCE_DIR}/assets/umicom-logo.svg"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-logo-on-dark.svg"
            "${CMAKE_CURRENT_SOURCE_DIR}/assets/umicom-logo-on-dark.svg"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom.ico"
            "${CMAKE_CURRENT_SOURCE_DIR}/win/umicom.ico"
            COPYONLY)

        message(STATUS
            "Staged Framework-owned shared resources for the current Studio module")
    endif()
endif()

# Native suite products share one Framework GTK4 adapter. Enabling any product
# with a native workstation therefore makes the adapter available before its
# thin application subdirectory is evaluated.
if((UMICOM_APPLICATIONS_BUILD_STUDIO AND UMICOM_STUDIO_BUILD_GTK) OR
   (UMICOM_APPLICATIONS_BUILD_DESKTOP AND UMICOM_DESKTOP_BUILD_GTK) OR
   (UMICOM_APPLICATIONS_BUILD_TRADER AND UMICOM_TRADER_BUILD_GTK4) OR
   UMICOM_APPLICATIONS_BUILD_BANK OR
   UMICOM_APPLICATIONS_BUILD_TMS OR
   UMICOM_APPLICATIONS_BUILD_MUSIC_STUDIO)
    set(UMICOM_BUILD_GTK4_ADAPTER ON CACHE BOOL
        "Build the Framework GTK4 adapter required by enabled applications" FORCE)
# Use this fallback path when the earlier condition does not apply.
else()
    set(UMICOM_BUILD_GTK4_ADAPTER OFF CACHE BOOL
        "Build the Framework GTK4 adapter required by enabled applications" FORCE)
endif()

umicom_require_cmake_project("framework" "Umicom Framework")
set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "Framework")
add_subdirectory(framework)

# Load the dependency only when the parent build has not already provided its target.
if(NOT TARGET Umicom::Framework)
    message(FATAL_ERROR
        "framework/CMakeLists.txt did not provide the required Umicom::Framework target.")
endif()

# Add the application runtime and Desk sources to the established Framework
# targets without creating a second Framework build catalogue.
include(
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/cmake/UmicomApplicationRuntimeIntegration.cmake"
)

# Attach canonical application experience and runtime/readiness projections.
include(
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/cmake/UmicomApplicationExperienceIntegration.cmake"
)

# The source-superbuild publishes an explicit default root for Framework-owned
# immutable resources. Installed consumers may call the same resolver with the
# package resource root discovered beside their installation prefix.
if(TARGET umicom_application)
    target_compile_definitions(umicom_application PRIVATE
        UMICOM_FRAMEWORK_RESOURCE_ROOT_DEFAULT="${UMICOM_FRAMEWORK_RESOURCE_ROOT}")
endif()

# -----------------------------------------------------------------------------
# Thin Umicom Desk composition
# -----------------------------------------------------------------------------
if(UMICOM_APPLICATIONS_BUILD_DESKTOP)
    umicom_require_cmake_project(
        "applications/desktop" "Umicom Desktop Module")
    set(UMICOM_DESKTOP_COMPOSE_STUDIO
        "${UMICOM_APPLICATIONS_BUILD_STUDIO}" CACHE BOOL
        "Expose Studio in Umicom Desk" FORCE)
    set(UMICOM_DESKTOP_COMPOSE_TRADER
        "${UMICOM_APPLICATIONS_BUILD_TRADER}" CACHE BOOL
        "Expose Trader in Umicom Desk" FORCE)
    set(UMICOM_DESKTOP_COMPOSE_BANK
        "${UMICOM_APPLICATIONS_BUILD_BANK}" CACHE BOOL
        "Expose Bank in Umicom Desk" FORCE)
    set(UMICOM_DESKTOP_COMPOSE_TMS
        "${UMICOM_APPLICATIONS_BUILD_TMS}" CACHE BOOL
        "Expose TMS in Umicom Desk" FORCE)
    set(UMICOM_DESKTOP_COMPOSE_OS
        "${UMICOM_APPLICATIONS_BUILD_OS}" CACHE BOOL
        "Expose OS Control Centre in Umicom Desk" FORCE)
    # Create this optional product surface only when its build option is enabled.
    if(UMICOM_STUDIO_BUILD_GTK)
        set(UMICOM_DESKTOP_STUDIO_EXECUTABLE "umicom-studio-ide" CACHE STRING
            "Studio executable registered with Umicom Desk" FORCE)
    # Use this fallback path when the earlier condition does not apply.
    else()
        set(UMICOM_DESKTOP_STUDIO_EXECUTABLE "umicom-studio-console" CACHE STRING
            "Studio executable registered with Umicom Desk" FORCE)
    endif()
    # Create this optional product surface only when its build option is enabled.
    if(UMICOM_TRADER_BUILD_GTK4)
        set(UMICOM_DESKTOP_TRADER_EXECUTABLE "umicom-trader" CACHE STRING
            "Trader executable registered with Umicom Desk" FORCE)
    # Use this fallback path when the earlier condition does not apply.
    else()
        set(UMICOM_DESKTOP_TRADER_EXECUTABLE "umicom-trader-console" CACHE STRING
            "Trader executable registered with Umicom Desk" FORCE)
    endif()
    set(UMICOM_DESKTOP_BANK_EXECUTABLE "umicom-bank" CACHE STRING
        "Bank executable registered with Umicom Desk" FORCE)
    set(UMICOM_DESKTOP_TMS_EXECUTABLE "umicom-tms" CACHE STRING
        "TMS executable registered with Umicom Desk" FORCE)
    set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "Desktop")
    add_subdirectory(applications/desktop)
    set_property(GLOBAL APPEND PROPERTY UMICOM_SUITE_COMPONENT_IDS "Desktop")
    set_property(GLOBAL APPEND PROPERTY UMICOM_SUITE_COMPONENT_NAMES
        "Umicom Applications Launcher")
    set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "Framework")
    # Load the dependency only when the parent build has not already provided its target.
    if(NOT TARGET Umicom::desktop_module)
        message(FATAL_ERROR
            "The Desktop module did not provide Umicom::desktop_module.")
    endif()
    message(STATUS "Enabled application module: Umicom Desk")
# Use this fallback path when the earlier condition does not apply.
else()
    message(STATUS "Disabled application module: Umicom Desk")
endif()

# -----------------------------------------------------------------------------
# Studio reference workbench
# -----------------------------------------------------------------------------
if(UMICOM_APPLICATIONS_BUILD_STUDIO)
    umicom_require_cmake_project("applications/studio" "Umicom Studio IDE")
    set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "Studio")
    add_subdirectory(applications/studio)
    set_property(GLOBAL APPEND PROPERTY UMICOM_SUITE_COMPONENT_IDS "Studio")
    set_property(GLOBAL APPEND PROPERTY UMICOM_SUITE_COMPONENT_NAMES
        "Umicom Studio IDE")

    # Use the optional file only when it is present in this checkout.
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/applications/studio/cmake/UmicomStudioExperienceIntegration.cmake")
        include("${CMAKE_CURRENT_SOURCE_DIR}/applications/studio/cmake/UmicomStudioExperienceIntegration.cmake")
    endif()

    # These bounded Studio features deliberately remain sibling subprojects of
    # the primary Studio module, matching the previous runnable Studio build.
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/applications/studio/runtime-manager/CMakeLists.txt")
        add_subdirectory(applications/studio/runtime-manager)
    endif()
    # Use the optional file only when it is present in this checkout.
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/applications/studio/workspace-productivity/CMakeLists.txt")
        add_subdirectory(applications/studio/workspace-productivity)
    endif()
    set(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME "Framework")

    # Load the dependency only when the parent build has not already provided its target.
    if(NOT TARGET Umicom::StudioCore)
        message(FATAL_ERROR
            "The Studio application module did not provide Umicom::StudioCore.")
    endif()

    message(STATUS "Enabled application module: Umicom Studio IDE")
# Use this fallback path when the earlier condition does not apply.
else()
    message(STATUS "Disabled application module: Umicom Studio IDE")
endif()

# -----------------------------------------------------------------------------
# User-space Umicom OS Control Centre
# -----------------------------------------------------------------------------
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_OS
    "applications/os"
    "Umicom OS Control Centre"
    "OperatingSystem")

# Placeholder and future product modules.
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_TRADER
    "applications/trader"
    "Umicom Trader"
    "Trader")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_TMS
    "applications/tms"
    "Umicom TMS"
    "TMS")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_LLM
    "applications/llm"
    "Umicom LLM")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_BANK
    "applications/bank"
    "Umicom Bank"
    "Bank")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_EXCHANGE
    "applications/exchange"
    "Umicom Exchange")

# Add the extended thin application modules after the established core products.
umicom_add_extended_application_modules()

# Register verification targets only when the developer has enabled testing.
if(BUILD_TESTING AND
   COMMAND umicom_register_header_portfolio_governance_test)
    set(UMICOM_APPLICATION_HEADER_ROOTS
        "${CMAKE_CURRENT_SOURCE_DIR}/framework/include")
    file(GLOB UMICOM_APPLICATION_INCLUDE_ROOTS
        LIST_DIRECTORIES TRUE
        "${CMAKE_CURRENT_SOURCE_DIR}/applications/*/include")
    list(APPEND UMICOM_APPLICATION_HEADER_ROOTS
        ${UMICOM_APPLICATION_INCLUDE_ROOTS})
    list(REMOVE_DUPLICATES UMICOM_APPLICATION_HEADER_ROOTS)
    umicom_register_header_portfolio_governance_test(
        applications.sdk.public_headers
        "Umicom Applications"
        ${UMICOM_APPLICATION_HEADER_ROOTS})

    set(UMICOM_APPLICATION_SOURCE_ROOTS
        "${CMAKE_CURRENT_SOURCE_DIR}/framework"
        "${CMAKE_CURRENT_SOURCE_DIR}/applications")
    umicom_register_source_comment_governance_test(
        applications.source.comments
        "Umicom Applications"
        ${UMICOM_APPLICATION_SOURCE_ROOTS})
    umicom_register_declaration_dependency_audit_test(
        applications.catalogue.declaration_dependencies
        ${UMICOM_APPLICATION_SOURCE_ROOTS})
endif()

# Keep the thorough repository documentation scan as an explicit developer
# target so an ordinary application build is not slowed by reading every
# source file. The audit is read-only and does not start compiled programs.
if(WIN32 AND EXISTS
   "${CMAKE_CURRENT_SOURCE_DIR}/scripts/umicom-document-source.ps1")
    find_program(UMICOM_DOCUMENTATION_POWERSHELL
        NAMES pwsh powershell)
    # Register the target only when the host can execute the checked-in script.
    if(UMICOM_DOCUMENTATION_POWERSHELL)
        add_custom_target(umicom-source-documentation-audit
            COMMAND
                "${UMICOM_DOCUMENTATION_POWERSHELL}"
                -NoProfile
                -ExecutionPolicy Bypass
                -File
                "${CMAKE_CURRENT_SOURCE_DIR}/scripts/umicom-document-source.ps1"
                -Mode Audit
                -ProjectRoot "${CMAKE_CURRENT_SOURCE_DIR}"
                -IncludeTemplates
            WORKING_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}"
            COMMENT "Auditing Umicom source explanations"
            VERBATIM)
    endif()
endif()

# Umicom Desk discovers installed applications through the Framework runtime
# catalogue. It therefore does not need build-time dependencies on every
# application executable; removing that false coupling lets Desk rebuild alone.

# Register verification targets only when the developer has enabled testing.
if(BUILD_TESTING)
    umicom_assert_single_root_test_tree()
    add_subdirectory(tests)
endif()

# -----------------------------------------------------------------------------
# Umicom Automated Build System target catalogue
# -----------------------------------------------------------------------------
# These generated aggregate targets give the Framework planner stable names
# that work in both graphical and headless presets. Application manifests are
# the source of truth, so adding an application does not require adding another
# hard-coded branch to the command-line tool.
add_custom_target(umicom-products)
set(_umicom_automation_application_slugs "")
file(GLOB _umicom_automation_application_manifests
    RELATIVE "${CMAKE_CURRENT_SOURCE_DIR}"
    "${CMAKE_CURRENT_SOURCE_DIR}/applications/*/application.umicom.yaml")
list(SORT _umicom_automation_application_manifests)

# Create one stable product target for each discovered application manifest.
foreach(_umicom_automation_manifest
        IN LISTS _umicom_automation_application_manifests)
    get_filename_component(_umicom_automation_application_directory
        "${_umicom_automation_manifest}" DIRECTORY)
    get_filename_component(_umicom_automation_slug
        "${_umicom_automation_application_directory}" NAME)
    set(_umicom_automation_scope_target
        "umicom-product-${_umicom_automation_slug}")

    # Read only the primary executable field from the small stable manifest
    # subset. The runtime parser remains authoritative for full validation.
    file(STRINGS
        "${CMAKE_CURRENT_SOURCE_DIR}/${_umicom_automation_manifest}"
        _umicom_automation_executable_lines
        REGEX "^[ \\t]+executable:[ \\t]*"
        LIMIT_COUNT 1)
    set(_umicom_automation_manifest_executable "")
    if(_umicom_automation_executable_lines)
        list(GET _umicom_automation_executable_lines 0
            _umicom_automation_manifest_executable)
        string(REGEX REPLACE "^[ \\t]*executable:[ \\t]*" ""
            _umicom_automation_manifest_executable
            "${_umicom_automation_manifest_executable}")
        string(STRIP "${_umicom_automation_manifest_executable}"
            _umicom_automation_manifest_executable)
    endif()

    # Prefer the normal graphical name, then the manifest entry and finally
    # console fallbacks. Only an executable target can become the product root.
    set(_umicom_automation_primary_candidates
        "umicom-${_umicom_automation_slug}"
        "${_umicom_automation_manifest_executable}"
        "${_umicom_automation_manifest_executable}-console"
        "umicom-${_umicom_automation_slug}-console")
    set(_umicom_automation_primary_target "")
    foreach(_umicom_automation_candidate
            IN LISTS _umicom_automation_primary_candidates)
        if(_umicom_automation_candidate AND
           TARGET "${_umicom_automation_candidate}")
            get_target_property(_umicom_automation_candidate_type
                "${_umicom_automation_candidate}" TYPE)
            if(_umicom_automation_candidate_type STREQUAL "EXECUTABLE")
                set(_umicom_automation_primary_target
                    "${_umicom_automation_candidate}")
                break()
            endif()
        endif()
    endforeach()
    if(_umicom_automation_primary_target)
        # Only configured applications receive runnable aggregate targets. A
        # changed but disabled product then fails clearly as an unknown target
        # instead of reporting a misleading successful no-op build.
        list(APPEND _umicom_automation_application_slugs
            "${_umicom_automation_slug}")
        add_custom_target(${_umicom_automation_scope_target})
        add_dependencies(${_umicom_automation_scope_target}
            "${_umicom_automation_primary_target}")
        add_dependencies(umicom-products ${_umicom_automation_scope_target})
    endif()
endforeach()

# Building the native command also builds the exported Framework aggregate, so
# it is the lightweight product root for shared Framework implementation work.
if(TARGET umicom)
    add_dependencies(umicom-products umicom)
elseif(TARGET umicom-framework-demo)
    add_dependencies(umicom-products umicom-framework-demo)
endif()

# Recursively collect targets that already exist after every application and
# test tree has been configured. The result is local configuration metadata;
# no generated file or source-tree mutation is required.
function(umicom_collect_buildsystem_targets directory output_variable)
    get_property(_umicom_directory_targets
        DIRECTORY "${directory}" PROPERTY BUILDSYSTEM_TARGETS)
    get_property(_umicom_child_directories
        DIRECTORY "${directory}" PROPERTY SUBDIRECTORIES)
    set(_umicom_collected_targets ${_umicom_directory_targets})
    foreach(_umicom_child_directory IN LISTS _umicom_child_directories)
        umicom_collect_buildsystem_targets(
            "${_umicom_child_directory}" _umicom_child_targets)
        list(APPEND _umicom_collected_targets ${_umicom_child_targets})
    endforeach()
    set(${output_variable} ${_umicom_collected_targets} PARENT_SCOPE)
endfunction()

umicom_collect_buildsystem_targets(
    "${CMAKE_CURRENT_SOURCE_DIR}" _umicom_automation_existing_targets)
list(REMOVE_DUPLICATES _umicom_automation_existing_targets)
add_custom_target(umicom-tests)
add_custom_target(umicom-tests-framework)
add_custom_target(umicom-tests-integration)
foreach(_umicom_automation_slug
        IN LISTS _umicom_automation_application_slugs)
    add_custom_target("umicom-tests-${_umicom_automation_slug}")
endforeach()

# Test executable naming is already governed by the repository's -test/-tests
# convention. Grouping those targets by their declaring source directory lets
# the automated planner compile tests for one affected application at a time.
foreach(_umicom_automation_target
        IN LISTS _umicom_automation_existing_targets)
    if(NOT TARGET "${_umicom_automation_target}" OR
       NOT _umicom_automation_target MATCHES "(^|-)tests?($|-)")
        continue()
    endif()
    get_target_property(_umicom_automation_target_type
        "${_umicom_automation_target}" TYPE)
    if(NOT _umicom_automation_target_type STREQUAL "EXECUTABLE")
        continue()
    endif()
    add_dependencies(umicom-tests "${_umicom_automation_target}")
    get_target_property(_umicom_automation_target_source_directory
        "${_umicom_automation_target}" SOURCE_DIR)
    file(RELATIVE_PATH _umicom_automation_target_relative_directory
        "${CMAKE_CURRENT_SOURCE_DIR}"
        "${_umicom_automation_target_source_directory}")
    if(_umicom_automation_target_relative_directory MATCHES
       "^framework($|/)")
        add_dependencies(umicom-tests-framework
            "${_umicom_automation_target}")
    elseif(_umicom_automation_target_relative_directory MATCHES
           "^tests($|/)")
        # Root tests verify contracts shared across applications. They belong
        # to the small integration group used by every affected scope.
        add_dependencies(umicom-tests-integration
            "${_umicom_automation_target}")
    elseif(_umicom_automation_target_relative_directory MATCHES
           "^applications/([^/]+)($|/)")
        set(_umicom_automation_test_slug "${CMAKE_MATCH_1}")
        if(TARGET "umicom-tests-${_umicom_automation_test_slug}")
            add_dependencies(
                "umicom-tests-${_umicom_automation_test_slug}"
                "${_umicom_automation_target}")
        endif()
    endif()
endforeach()

# An application or Framework change can break the suite-level composition
# contracts declared by the root test tree. Attach that bounded group to each
# focused target so incremental testing remains safe without compiling every
# unrelated application's private tests.
add_dependencies(umicom-tests-framework umicom-tests-integration)
foreach(_umicom_automation_slug
        IN LISTS _umicom_automation_application_slugs)
    add_dependencies("umicom-tests-${_umicom_automation_slug}"
        umicom-tests-integration)
endforeach()

# Register verification targets only when the developer has enabled testing.
if(BUILD_TESTING AND UMICOM_BUILD_REGISTERED_VALIDATION_TARGETS)
    get_property(_umicom_registered_validation_targets GLOBAL PROPERTY
        UMICOM_REGISTERED_VALIDATION_TARGETS)
    # Apply this operation only while the related capability or state is available.
    if(_umicom_registered_validation_targets)
        list(REMOVE_DUPLICATES _umicom_registered_validation_targets)
        # Keep this legacy closure explicit. Product targets must never acquire
        # thousands of validation dependencies merely because testing is on.
        add_custom_target(umicom-registered-validation-tests)
        add_dependencies(umicom-registered-validation-tests
            ${_umicom_registered_validation_targets})
        list(LENGTH _umicom_registered_validation_targets
            _umicom_registered_validation_target_count)
        message(STATUS
            "Registered validation target closure: ${_umicom_registered_validation_target_count} executables")
    endif()
endif()

# Shared resources are installed once beside the modular Framework runtime.
# Application-specific resources continue to be installed by their owner.
install(DIRECTORY "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/umicom/resources")
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/licenses/umicom-applications")

# Windows packages use CPack's component-aware installer so users can choose
# applications with checkboxes. Portable archives remain available for manual
# and offline installation.
set(CPACK_PACKAGE_NAME "Umicom Applications")
set(CPACK_PACKAGE_VENDOR "Umicom Foundation")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "Umicom Desk, Framework and independently versioned application modules")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_FILE_NAME
    "umicom-applications-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}")
# Apply this branch only when its contract condition is satisfied.
if(WIN32)
    set(CPACK_GENERATOR "NSIS;ZIP")
    set(CPACK_NSIS_COMPONENT_INSTALL ON)
    set(CPACK_NSIS_DISPLAY_NAME "Umicom Applications")
    set(CPACK_NSIS_PACKAGE_NAME "Umicom Applications")
    set(CPACK_NSIS_MUI_ICON
        "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom.ico")
    set(CPACK_NSIS_MUI_UNIICON
        "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom.ico")
    set(CPACK_NSIS_ENABLE_UNINSTALL_BEFORE_INSTALL ON)
    # Offer an explicit installer choice to add the installed bin directory to
    # PATH. CPack also removes that exact entry during uninstall, avoiding a
    # permanent machine change when the user does not request one.
    set(CPACK_NSIS_MODIFY_PATH ON)
    set(CPACK_PACKAGE_INSTALL_DIRECTORY "Umicom Applications")
    set(CPACK_PACKAGE_EXECUTABLES
        "umicom-desk" "Umicom Applications")
    set(CPACK_CREATE_DESKTOP_LINKS "umicom-desk")
# Use this fallback path when the earlier condition does not apply.
else()
    set(CPACK_GENERATOR "TGZ;ZIP")
endif()

include(CPackComponent)
cpack_add_component_group(UmicomApplications
    DISPLAY_NAME "Umicom Applications"
    DESCRIPTION "Choose the Umicom applications to install.")
cpack_add_component(Framework
    DISPLAY_NAME "Umicom Framework"
    DESCRIPTION "Shared runtime, components, contracts and resources."
    REQUIRED
    HIDDEN)

get_property(_umicom_suite_component_ids GLOBAL PROPERTY
    UMICOM_SUITE_COMPONENT_IDS)
get_property(_umicom_suite_component_names GLOBAL PROPERTY
    UMICOM_SUITE_COMPONENT_NAMES)
# Use the stable identifier comparison to choose the matching record or policy.
if(_umicom_suite_component_ids)
    list(LENGTH _umicom_suite_component_ids
        _umicom_suite_component_count)
    list(LENGTH _umicom_suite_component_names
        _umicom_suite_component_name_count)
    # Use the stable identifier comparison to choose the matching record or policy.
    if(NOT _umicom_suite_component_count EQUAL
       _umicom_suite_component_name_count)
        message(FATAL_ERROR
            "Installer component identifiers and names are out of sync")
    endif()
    set(CPACK_COMPONENTS_ALL Framework
        ${_umicom_suite_component_ids})
    math(EXPR _umicom_suite_component_last
        "${_umicom_suite_component_count} - 1")
    # Visit each bounded item once so every record receives the same rule.
    foreach(_umicom_suite_component_index
            RANGE 0 ${_umicom_suite_component_last})
        list(GET _umicom_suite_component_ids
            ${_umicom_suite_component_index}
            _umicom_suite_component_id)
        list(GET _umicom_suite_component_names
            ${_umicom_suite_component_index}
            _umicom_suite_component_name)
        # Use the stable identifier comparison to choose the matching record or policy.
        if(_umicom_suite_component_id STREQUAL "Desktop")
            cpack_add_component(${_umicom_suite_component_id}
                DISPLAY_NAME "${_umicom_suite_component_name}"
                DESCRIPTION
                    "Application chooser and multi-application launcher."
                DEPENDS Framework
                REQUIRED
                GROUP UmicomApplications)
        # Use this fallback path when the earlier condition does not apply.
        else()
            cpack_add_component(${_umicom_suite_component_id}
                DISPLAY_NAME "${_umicom_suite_component_name}"
                DESCRIPTION
                    "Install ${_umicom_suite_component_name}."
                DEPENDS Framework
                GROUP UmicomApplications)
        endif()
    endforeach()
endif()
include(CPack)

message(STATUS "Umicom Applications version: ${PROJECT_VERSION}")
message(STATUS "C standard: C${CMAKE_C_STANDARD}")
message(STATUS "Build type: ${CMAKE_BUILD_TYPE}")
message(STATUS "Umicom Desk GTK4 application: ${UMICOM_DESKTOP_BUILD_GTK}")
message(STATUS "Studio GTK4 application: ${UMICOM_STUDIO_BUILD_GTK}")
message(STATUS "OS Control Centre: ${UMICOM_APPLICATIONS_BUILD_OS}")
message(STATUS "Framework source: ${CMAKE_CURRENT_SOURCE_DIR}/framework")
message(STATUS "Framework resources: ${UMICOM_FRAMEWORK_RESOURCE_ROOT}")
