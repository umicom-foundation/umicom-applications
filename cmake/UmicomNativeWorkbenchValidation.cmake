#-----------------------------------------------------------------------------
# Umicom Applications
# File: cmake/UmicomNativeWorkbenchValidation.cmake
#
# PURPOSE:
#   Build focused workbench regression executables without relinking products.
#
# AUTHOR AND ORGANISATION:
# Sammy Hegab
# Umicom Foundation
#
# LICENCE:
# MIT
#-----------------------------------------------------------------------------
include_guard(GLOBAL)

# A build-only aggregate is not a test result. Headless configurations retain
# portable coverage and explicitly report every unavailable native fixture.
if(NOT BUILD_TESTING)
    return()
endif()

# Follow declared target dependencies, including targets named inside link
# generator expressions. Inspect all configurations conservatively: a product
# executable in any branch needs review before it joins this focused closure.
function(umicom_assert_native_workbench_test_closure)
    set(_umicom_allowed_tests ${ARGN})
    set(_umicom_pending_targets ${ARGN})
    set(_umicom_visited_targets)
    while(_umicom_pending_targets)
        list(POP_FRONT _umicom_pending_targets _umicom_target)
        if(NOT TARGET "${_umicom_target}")
            message(FATAL_ERROR
                "Native workbench dependency '${_umicom_target}' is missing")
        endif()
        get_target_property(_umicom_alias "${_umicom_target}" ALIASED_TARGET)
        if(_umicom_alias)
            set(_umicom_target "${_umicom_alias}")
        endif()
        if(_umicom_target IN_LIST _umicom_visited_targets)
            continue()
        endif()
        list(APPEND _umicom_visited_targets "${_umicom_target}")
        get_target_property(_umicom_imported "${_umicom_target}" IMPORTED)
        if(_umicom_imported)
            continue()
        endif()
        get_target_property(_umicom_type "${_umicom_target}" TYPE)
        if((_umicom_type STREQUAL "EXECUTABLE" AND
            NOT _umicom_target IN_LIST _umicom_allowed_tests) OR
           _umicom_target STREQUAL "umicom-products" OR
           _umicom_target STREQUAL "umicom-desktop-products")
            message(FATAL_ERROR
                "Native workbench tests must not build product target '${_umicom_target}'")
        endif()
        foreach(_umicom_property IN ITEMS MANUALLY_ADDED_DEPENDENCIES
                LINK_LIBRARIES INTERFACE_LINK_LIBRARIES)
            get_target_property(_umicom_links "${_umicom_target}" "${_umicom_property}")
            if(NOT _umicom_links)
                continue()
            endif()
            # Non-target tokens such as paths, flags and generator-expression
            # operators are ignored. Aliases are resolved on the next visit.
            string(REGEX MATCHALL "[A-Za-z0-9_.+-]+(::[A-Za-z0-9_.+-]+)*"
                _umicom_tokens "${_umicom_links}")
            foreach(_umicom_token IN LISTS _umicom_tokens)
                if(TARGET "${_umicom_token}")
                    list(APPEND _umicom_pending_targets "${_umicom_token}")
                endif()
            endforeach()
        endforeach()
    endwhile()
endfunction()

# The original failure set includes two manifest checks and a portable mode
# contract. Discovery/path checks and the closure guard protect recent changes.
set(_umicom_native_workbench_portable_targets
    umicom-application-manifest-tests
    umicom-applications-native-manifest-test
    umicom-ui-workstation-maximize-mode-test
    umicom-application-native-discovery-test
    umicom-platform-executable-path-test
    umicom-workspace-library-test
    umicom-ui-workspace-checkpoint-test
    umicom-ui-workspace-library-checkpoint-test
    umicom-applications-validation-target-closure-test)
set(_umicom_native_workbench_gtk_targets
    umicom-gtk4-workspace-maximise-test
    umicom-gtk4-suite-navigation-test
    umicom-gtk4-command-bar-lifetime-test
    umicom-gtk4-desk-home-test
    umicom-gtk4-layout-library-test
    umicom-gtk4-workspace-canvas-test
    umicom-gtk4-workspace-checkpoint-test
    umicom-gtk4-workspace-content-test)
set(_umicom_native_workbench_product_test_targets
    umicom-desktop-window-titlebar-test
    umicom-studio-workspace-canvas-test)

set(_umicom_native_workbench_targets)
set(_umicom_native_workbench_omitted)
foreach(_umicom_target IN LISTS _umicom_native_workbench_portable_targets)
    if(NOT TARGET "${_umicom_target}")
        message(FATAL_ERROR
            "Required portable workbench regression '${_umicom_target}' is missing")
    endif()
    list(APPEND _umicom_native_workbench_targets "${_umicom_target}")
endforeach()
foreach(_umicom_target IN LISTS _umicom_native_workbench_gtk_targets
        _umicom_native_workbench_product_test_targets)
    if(TARGET "${_umicom_target}")
        list(APPEND _umicom_native_workbench_targets "${_umicom_target}")
    else()
        # Disabled renderers/products may omit their fixtures. An enabled
        # renderer losing a required fixture is a graph error, not a skip.
        if((TARGET Umicom::ui_gtk4 AND
            _umicom_target IN_LIST _umicom_native_workbench_gtk_targets) OR
           (_umicom_target STREQUAL "umicom-desktop-window-titlebar-test" AND
            UMICOM_APPLICATIONS_BUILD_DESKTOP AND UMICOM_DESKTOP_BUILD_GTK) OR
           (_umicom_target STREQUAL "umicom-studio-workspace-canvas-test" AND
            UMICOM_APPLICATIONS_BUILD_STUDIO AND UMICOM_STUDIO_BUILD_GTK))
            message(FATAL_ERROR
                "Enabled native workbench regression '${_umicom_target}' is missing")
        endif()
        list(APPEND _umicom_native_workbench_omitted "${_umicom_target}")
    endif()
endforeach()

umicom_assert_native_workbench_test_closure(${_umicom_native_workbench_targets})
list(LENGTH _umicom_native_workbench_targets _umicom_native_workbench_count)
set(_umicom_native_workbench_note
    "Built ${_umicom_native_workbench_count} focused regression executables. CTest has not run.")
if(_umicom_native_workbench_omitted)
    list(JOIN _umicom_native_workbench_omitted ", " _umicom_native_workbench_missing_text)
    string(APPEND _umicom_native_workbench_note
        " Native coverage is incomplete in this configuration. Omitted: ${_umicom_native_workbench_missing_text}")
    message(STATUS
        "Native workbench regression configuration omits: ${_umicom_native_workbench_missing_text}. Native coverage will be incomplete.")
endif()

# No ALL flag, product aggregate, application executable or command execution
# belongs here. CTest is a separate explicit operation after a successful build.
add_custom_target(umicom-native-workbench-regression-tests
    COMMAND "${CMAKE_COMMAND}" -E echo "${_umicom_native_workbench_note}"
    VERBATIM)
add_dependencies(umicom-native-workbench-regression-tests
    ${_umicom_native_workbench_targets})
set_property(TARGET umicom-native-workbench-regression-tests PROPERTY
    UMICOM_NATIVE_WORKBENCH_OMITTED_TEST_TARGETS "${_umicom_native_workbench_omitted}")
