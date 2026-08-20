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
       OFF)
option(UMICOM_APPLICATIONS_BUILD_TMS
       "Build the Umicom Open TMS application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_LLM
       "Build the Umicom LLM application module"
       OFF)
option(UMICOM_APPLICATIONS_BUILD_BANK
       "Build the Umicom Bank application module"
       OFF)
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
option(UMICOM_APPLICATIONS_STAGE_FRAMEWORK_RESOURCES
       "Stage Framework-owned shared resources for compatibility with the current Studio module"
       ON)

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
    if(NOT UMICOM_ENABLE_STRICT_WARNINGS)
        return()
    endif()

    if(MSVC)
        target_compile_options(${target} PRIVATE /W4)
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

function(umicom_apply_sanitizers target)
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

function(umicom_require_cmake_project relative_path display_name)
    if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${relative_path}/CMakeLists.txt")
        message(FATAL_ERROR
            "${display_name} is enabled but ${relative_path}/CMakeLists.txt is missing. "
            "Initialise the submodule and ensure it contains application source.")
    endif()
endfunction()

function(umicom_require_framework_resource relative_path logical_id)
    if(NOT EXISTS "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/${relative_path}")
        message(FATAL_ERROR
            "Required Framework resource '${logical_id}' is missing at "
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/${relative_path}. Copy the exact "
            "canonical asset into framework/resources before configuring.")
    endif()
endfunction()

function(umicom_add_optional_application option_name relative_path display_name)
    if(${option_name})
        umicom_require_cmake_project("${relative_path}" "${display_name}")
        add_subdirectory("${relative_path}")
        message(STATUS "Enabled application module: ${display_name}")
    else()
        message(STATUS "Disabled application module: ${display_name}")
    endif()
endfunction()

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
        "brand/umicom-logo.svg" "umicom.brand.logo.primary")
    umicom_require_framework_resource(
        "brand/umicom-logo.png" "umicom.brand.logo.raster")
    umicom_require_framework_resource(
        "brand/umicom.ico" "umicom.brand.icon.windows")
    umicom_require_framework_resource(
        "windows/umicom-application.rc.in"
        "umicom.windows.application-resource-template")

    if(UMICOM_APPLICATIONS_STAGE_FRAMEWORK_RESOURCES)
        file(MAKE_DIRECTORY
            "${CMAKE_CURRENT_SOURCE_DIR}/assets"
            "${CMAKE_CURRENT_SOURCE_DIR}/win")

        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-icon.svg"
            "${CMAKE_CURRENT_SOURCE_DIR}/assets/umicom-icon.svg"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-logo.svg"
            "${CMAKE_CURRENT_SOURCE_DIR}/assets/umicom-logo.svg"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom-logo.png"
            "${CMAKE_CURRENT_SOURCE_DIR}/win/umicom-logo.png"
            COPYONLY)
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/brand/umicom.ico"
            "${CMAKE_CURRENT_SOURCE_DIR}/win/umicom.ico"
            COPYONLY)

        set(UMICOM_WINDOWS_FILE_VERSION "0,17,0,0")
        set(UMICOM_WINDOWS_PRODUCT_VERSION "0,17,0,0")
        set(UMICOM_WINDOWS_FILE_VERSION_TEXT "0.17.0.0")
        set(UMICOM_WINDOWS_PRODUCT_VERSION_TEXT "0.17.0.0")
        set(UMICOM_WINDOWS_FILE_DESCRIPTION "Umicom Studio IDE")
        set(UMICOM_WINDOWS_INTERNAL_NAME "umicom-studio-ide")
        set(UMICOM_WINDOWS_ORIGINAL_FILENAME "umicom-studio-ide.exe")
        set(UMICOM_WINDOWS_PRODUCT_NAME "Umicom Studio IDE")
        configure_file(
            "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/windows/umicom-application.rc.in"
            "${CMAKE_CURRENT_SOURCE_DIR}/win/umicom.rc"
            @ONLY
            NEWLINE_STYLE WIN32)

        message(STATUS
            "Staged Framework-owned shared resources for the current Studio module")
    endif()
endif()

# Studio and Umicom Desk require the Framework GTK4 adapter when either
# graphical application is built.
if((UMICOM_APPLICATIONS_BUILD_STUDIO AND UMICOM_STUDIO_BUILD_GTK) OR
   (UMICOM_APPLICATIONS_BUILD_DESKTOP AND UMICOM_DESKTOP_BUILD_GTK))
    set(UMICOM_BUILD_GTK4_ADAPTER ON CACHE BOOL
        "Build the Framework GTK4 adapter required by enabled applications" FORCE)
else()
    set(UMICOM_BUILD_GTK4_ADAPTER OFF CACHE BOOL
        "Build the Framework GTK4 adapter required by enabled applications" FORCE)
endif()

umicom_require_cmake_project("framework" "Umicom Framework")
add_subdirectory(framework)

if(NOT TARGET Umicom::Framework)
    message(FATAL_ERROR
        "framework/CMakeLists.txt did not provide the required Umicom::Framework target.")
endif()

# Add the application runtime and Desk sources to the established Framework
# targets without creating a second Framework build catalogue.
include(
    "${CMAKE_CURRENT_SOURCE_DIR}/framework/cmake/UmicomApplicationRuntimeIntegration.cmake"
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
    set(UMICOM_DESKTOP_COMPOSE_OS
        "${UMICOM_APPLICATIONS_BUILD_OS}" CACHE BOOL
        "Expose OS Control Centre in Umicom Desk" FORCE)
    add_subdirectory(applications/desktop)
    if(NOT TARGET Umicom::desktop_module)
        message(FATAL_ERROR
            "The Desktop module did not provide Umicom::desktop_module.")
    endif()
    message(STATUS "Enabled application module: Umicom Desk")
else()
    message(STATUS "Disabled application module: Umicom Desk")
endif()

# -----------------------------------------------------------------------------
# Studio reference workbench
# -----------------------------------------------------------------------------
if(UMICOM_APPLICATIONS_BUILD_STUDIO)
    umicom_require_cmake_project("applications/studio" "Umicom Studio IDE")
    add_subdirectory(applications/studio)

    # These bounded Studio features deliberately remain sibling subprojects of
    # the primary Studio module, matching the previous runnable Studio build.
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/applications/studio/runtime-manager/CMakeLists.txt")
        add_subdirectory(applications/studio/runtime-manager)
    endif()
    if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/applications/studio/workspace-productivity/CMakeLists.txt")
        add_subdirectory(applications/studio/workspace-productivity)
    endif()

    if(NOT TARGET Umicom::StudioCore)
        message(FATAL_ERROR
            "The Studio application module did not provide Umicom::StudioCore.")
    endif()

    message(STATUS "Enabled application module: Umicom Studio IDE")
else()
    message(STATUS "Disabled application module: Umicom Studio IDE")
endif()

# -----------------------------------------------------------------------------
# User-space Umicom OS Control Centre
# -----------------------------------------------------------------------------
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_OS
    "applications/os"
    "Umicom OS Control Centre")

# Placeholder and future product modules.
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_TRADER
    "applications/trader"
    "Umicom Trader")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_TMS
    "applications/tms"
    "Umicom Open TMS")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_LLM
    "applications/llm"
    "Umicom LLM")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_BANK
    "applications/bank"
    "Umicom Bank")
umicom_add_optional_application(
    UMICOM_APPLICATIONS_BUILD_EXCHANGE
    "applications/exchange"
    "Umicom Exchange")

if(TARGET umicom-desk AND TARGET umicom-studio-ide)
    add_dependencies(umicom-desk umicom-studio-ide)
endif()
if(TARGET umicom-desk AND TARGET umicom-os-control-centre)
    add_dependencies(umicom-desk umicom-os-control-centre)
endif()

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

# Shared resources are installed once beside the modular Framework runtime.
# Application-specific resources continue to be installed by their owner.
install(DIRECTORY "${UMICOM_FRAMEWORK_RESOURCE_ROOT}/"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/umicom/resources")
install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/licenses/umicom-applications")

# Portable archives remain the initial package format. Platform-specific
# signed installers remain governed by the delivery roadmap.
set(CPACK_PACKAGE_NAME "Umicom Applications")
set(CPACK_PACKAGE_VENDOR "Umicom Foundation")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "Umicom Desk, Framework and independently versioned application modules")
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
set(CPACK_PACKAGE_FILE_NAME
    "umicom-applications-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}")
if(WIN32)
    set(CPACK_GENERATOR "ZIP")
else()
    set(CPACK_GENERATOR "TGZ;ZIP")
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
