#-----------------------------------------------------------------------------
# Umicom Applications
# File: CMakeLists.txt
#
# PURPOSE:
#   Compose one authoritative Umicom Framework checkout with independently
#   versioned thin application modules. Repository Batch R1 enables Studio as
#   the first runnable application while retaining the remaining application
#   repositories as disabled, reproducibly pinned composition members.
#
# ARCHITECTURE:
#   - Framework is configured exactly once from framework/.
#   - Application modules consume public Framework targets only.
#   - Studio is the first enabled application and reference integration host.
#   - Placeholder application modules never block an unrelated Studio build.
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
    VERSION 0.1.0
    DESCRIPTION "Runnable composition of Umicom Framework and thin application modules"
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

option(UMICOM_STUDIO_BUILD_GTK
       "Build the GTK4 Umicom Studio IDE application"
       ON)
option(UMICOM_STUDIO_GUI
       "Build Studio as a Windows GUI-subsystem executable"
       ON)
option(UMICOM_APPLICATIONS_REQUIRE_STUDIO_RESOURCES
       "Require the established Studio branding and Windows resources for GTK builds"
       ON)

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

function(umicom_add_optional_application option_name relative_path display_name)
    if(${option_name})
        umicom_require_cmake_project("${relative_path}" "${display_name}")
        add_subdirectory("${relative_path}")
        message(STATUS "Enabled application module: ${display_name}")
    else()
        message(STATUS "Disabled application module: ${display_name}")
    endif()
endfunction()

# The current Studio module intentionally preserves its established resource
# references while the repository split is stabilised. The five resources are
# copied from the existing standalone Studio checkout into this composition
# root once; they are not generated, downloaded or silently replaced.
if(UMICOM_APPLICATIONS_BUILD_STUDIO AND
   UMICOM_STUDIO_BUILD_GTK AND
   UMICOM_APPLICATIONS_REQUIRE_STUDIO_RESOURCES)
    set(UMICOM_STUDIO_REQUIRED_RESOURCES
        assets/umicom-icon.svg
        assets/umicom-logo.svg
        win/umicom.rc
        win/umicom.ico
        win/umicom-logo.png
    )

    set(UMICOM_STUDIO_MISSING_RESOURCES "")
    foreach(UMICOM_STUDIO_RESOURCE IN LISTS UMICOM_STUDIO_REQUIRED_RESOURCES)
        if(NOT EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/${UMICOM_STUDIO_RESOURCE}")
            list(APPEND UMICOM_STUDIO_MISSING_RESOURCES
                "${UMICOM_STUDIO_RESOURCE}")
        endif()
    endforeach()

    if(UMICOM_STUDIO_MISSING_RESOURCES)
        list(JOIN UMICOM_STUDIO_MISSING_RESOURCES ", "
            UMICOM_STUDIO_MISSING_RESOURCE_TEXT)
        message(FATAL_ERROR
            "The GTK4 Studio build requires the existing product resources: "
            "${UMICOM_STUDIO_MISSING_RESOURCE_TEXT}. Copy those exact files "
            "from the current umicom-studio-ide repository before configuring, "
            "or use the headless preset while reviewing Repository Batch R1.")
    endif()
endif()

# Studio requires the Framework GTK4 adapter when its GTK application is built.
if(UMICOM_APPLICATIONS_BUILD_STUDIO AND UMICOM_STUDIO_BUILD_GTK)
    set(UMICOM_BUILD_GTK4_ADAPTER ON CACHE BOOL
        "Build the Framework GTK4 adapter required by Studio" FORCE)
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

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()

install(FILES "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE"
    DESTINATION "${CMAKE_INSTALL_DATADIR}/licenses/umicom-applications")

# Repository Batch R1 deliberately starts with portable archives. Platform-
# specific signed installers remain governed by the later delivery roadmap.
set(CPACK_PACKAGE_NAME "Umicom Applications")
set(CPACK_PACKAGE_VENDOR "Umicom Foundation")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY
    "Umicom Framework with independently versioned thin application modules")
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
message(STATUS "Studio GTK4 application: ${UMICOM_STUDIO_BUILD_GTK}")
message(STATUS "Framework source: ${CMAKE_CURRENT_SOURCE_DIR}/framework")
