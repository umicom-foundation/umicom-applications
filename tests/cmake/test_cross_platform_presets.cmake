#-----------------------------------------------------------------------------
# Umicom Applications
# File: tests/cmake/test_cross_platform_presets.cmake
# PURPOSE:
#   Verify the suite-owned all-module headless presets without configuring
#   unrelated application products or executing a compiler.
# AUTHOR AND ORGANISATION: Sammy Hegab, Umicom Foundation
# LICENCE: MIT
#-----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.24)
if(NOT DEFINED PRESET_FILE OR NOT EXISTS "${PRESET_FILE}")
    message(FATAL_ERROR "PRESET_FILE must identify the suite CMakePresets.json.")
endif()
file(READ "${PRESET_FILE}" presets)

function(find_preset kind name out)
    string(JSON count LENGTH "${presets}" "${kind}")
    math(EXPR last "${count} - 1")
    set(found FALSE)
    foreach(index RANGE 0 ${last})
        string(JSON candidate GET "${presets}" "${kind}" ${index} name)
        if(candidate STREQUAL name)
            if(found)
                message(FATAL_ERROR "Duplicate ${kind} entry: ${name}")
            endif()
            string(JSON entry GET "${presets}" "${kind}" ${index})
            set(found TRUE)
        endif()
    endforeach()
    if(NOT found)
        message(FATAL_ERROR "Missing ${kind} entry: ${name}")
    endif()
    set(${out} "${entry}" PARENT_SCOPE)
endfunction()

# The governed presets have single-parent inheritance. Bound traversal so a
# malformed cycle reports an error rather than hanging the test runner.
function(effective_cache name key out)
    set(current "${name}")
    set(visited)
    foreach(depth RANGE 0 15)
        if(current IN_LIST visited)
            message(FATAL_ERROR "Preset inheritance cycle: ${visited};${current}")
        endif()
        list(APPEND visited "${current}")
        find_preset(configurePresets "${current}" entry)
        string(JSON value ERROR_VARIABLE err GET "${entry}" cacheVariables "${key}")
        if(NOT err)
            set(${out} "${value}" PARENT_SCOPE)
            return()
        endif()
        string(JSON parent ERROR_VARIABLE err GET "${entry}" inherits)
        if(err)
            message(FATAL_ERROR "${name} has no effective ${key}")
        endif()
        set(current "${parent}")
    endforeach()
    message(FATAL_ERROR "Preset inheritance exceeds the fixture bound: ${name}")
endfunction()

set(names linux-all-headless-debug linux-gcc-all-headless-debug
    windows-ucrt64-all-headless-debug)
set(binary_dirs)
foreach(name IN LISTS names)
    find_preset(configurePresets "${name}" entry)
    string(JSON directory GET "${entry}" binaryDir)
    if(directory IN_LIST binary_dirs)
        message(FATAL_ERROR "Compiler/platform configurations share a build tree: ${directory}")
    endif()
    list(APPEND binary_dirs "${directory}")
    foreach(key IN ITEMS UMICOM_APPLICATIONS_BUILD_ALL_MODULES BUILD_TESTING
            UMICOM_ENABLE_STRICT_WARNINGS)
        effective_cache("${name}" "${key}" value)
        if(NOT value STREQUAL "ON")
            message(FATAL_ERROR "${name}: ${key} must remain ON")
        endif()
    endforeach()
    foreach(key IN ITEMS UMICOM_DESKTOP_BUILD_GTK UMICOM_STUDIO_BUILD_GTK
            UMICOM_TRADER_BUILD_GTK4 UMICOM_BANK_BUILD_GTK4 UMICOM_TMS_BUILD_GTK4
            UMICOM_MUSIC_STUDIO_BUILD_GTK4 UMICOM_APPLICATIONS_BUILD_SHARED_GTK4)
        effective_cache("${name}" "${key}" value)
        if(NOT value STREQUAL "OFF")
            message(FATAL_ERROR "${name}: graphical switch ${key} must remain OFF")
        endif()
    endforeach()
    effective_cache("${name}" CMAKE_C_COMPILER compiler)
    if(name STREQUAL "linux-all-headless-debug" AND NOT compiler STREQUAL "clang")
        message(FATAL_ERROR "The Linux Clang profile changed compiler.")
    elseif(name STREQUAL "linux-gcc-all-headless-debug" AND NOT compiler STREQUAL "gcc")
        message(FATAL_ERROR "The Linux GCC profile changed compiler.")
    elseif(name MATCHES "^windows" AND NOT compiler STREQUAL "C:/msys64/ucrt64/bin/gcc.exe")
        message(FATAL_ERROR "The Windows profile must use the established UCRT64 compiler.")
    endif()
    find_preset(buildPresets "${name}" build)
    find_preset(testPresets "${name}" test)
    string(JSON build_config GET "${build}" configurePreset)
    string(JSON test_config GET "${test}" configurePreset)
    string(JSON no_tests GET "${test}" execution noTestsAction)
    string(JSON show_failure GET "${test}" output outputOnFailure)
    if(NOT build_config STREQUAL name OR NOT test_config STREQUAL name OR
       NOT no_tests STREQUAL "error" OR NOT show_failure)
        message(FATAL_ERROR "${name}: build/test mapping or failure reporting is broken.")
    endif()
endforeach()

# Existing user workflows remain available; they are not renamed by this update.
foreach(name IN ITEMS headless-debug windows-ucrt64-headless-debug
        windows-ucrt64-debug windows-ucrt64-all-debug)
    find_preset(configurePresets "${name}" unused)
    find_preset(buildPresets "${name}" unused)
    find_preset(testPresets "${name}" unused)
endforeach()
message(STATUS "All-module headless presets preserve platform, compiler, testing and GUI boundaries.")
