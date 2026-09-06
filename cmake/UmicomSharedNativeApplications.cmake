#-----------------------------------------------------------------------------
# Umicom Applications
# File: cmake/UmicomSharedNativeApplications.cmake
#
# PURPOSE:
#   Give enabled thin modules a Framework-owned native layout host while
#   preserving dedicated frontends and each application's installer component.
#   Shared hosts expose catalogue layouts; domain actions require controllers.
#
# AUTHOR AND ORGANISATION:
#   Sammy Hegab
#   Umicom Foundation
#
# LICENCE:
#   MIT
#-----------------------------------------------------------------------------
include_guard(GLOBAL)

# Read the manifest's small stable application-identity fields. Runtime parsing
# remains owned by Framework; this helper only supplies executable build inputs.
function(umicom_native_manifest_field manifest field output_variable)
    file(STRINGS "${manifest}" _umicom_field_lines
        REGEX "^  ${field}: *" LIMIT_COUNT 1)
    if(NOT _umicom_field_lines)
        message(FATAL_ERROR "Missing ${field} in ${manifest}")
    endif()
    list(GET _umicom_field_lines 0 _umicom_field_value)
    string(REGEX REPLACE "^  ${field}: *" "" _umicom_field_value
        "${_umicom_field_value}")
    string(STRIP "${_umicom_field_value}" _umicom_field_value)
    set("${output_variable}" "${_umicom_field_value}" PARENT_SCOPE)
endfunction()

# Create native executables from configured module targets, even when their
# verification consoles are disabled. Never replace a dedicated product frontend.
function(umicom_add_shared_native_applications)
    if(NOT TARGET Umicom::ui_gtk4)
        return()
    endif()

    add_custom_target(umicom-desktop-products)
    foreach(_umicom_dedicated_target
            umicom-desk umicom-studio-ide umicom-trader
            umicom-bank umicom-tms umicom-music-studio)
        if(TARGET "${_umicom_dedicated_target}")
            add_dependencies(umicom-desktop-products
                "${_umicom_dedicated_target}")
        endif()
    endforeach()
    if(NOT UMICOM_APPLICATIONS_BUILD_SHARED_GTK4)
        return()
    endif()

    include("${CMAKE_CURRENT_SOURCE_DIR}/framework/cmake/UmicomApplicationBranding.cmake")
    get_property(_umicom_application_directories GLOBAL PROPERTY
        UMICOM_SUITE_APPLICATION_DIRECTORIES)
    foreach(_umicom_relative_directory IN LISTS _umicom_application_directories)
        get_filename_component(_umicom_slug "${_umicom_relative_directory}" NAME)
        if(_umicom_slug MATCHES "^(desktop|studio|trader|bank|tms|music)$")
            continue()
        endif()
        set(_umicom_directory
            "${CMAKE_CURRENT_SOURCE_DIR}/${_umicom_relative_directory}")
        get_property(_umicom_directory_targets DIRECTORY "${_umicom_directory}"
            PROPERTY BUILDSYSTEM_TARGETS)
        set(_umicom_module_target "")
        foreach(_umicom_candidate IN LISTS _umicom_directory_targets)
            if(_umicom_candidate MATCHES "^umicom_.*_module$")
                set(_umicom_module_target "${_umicom_candidate}")
                break()
            endif()
        endforeach()
        if(NOT _umicom_module_target)
            message(FATAL_ERROR
                "No thin application module target in ${_umicom_relative_directory}")
        endif()

        set(_umicom_manifest "${_umicom_directory}/application.umicom.yaml")
        umicom_native_manifest_field("${_umicom_manifest}" id _umicom_id)
        umicom_native_manifest_field("${_umicom_manifest}" name _umicom_title)
        umicom_native_manifest_field("${_umicom_manifest}" executable _umicom_executable)
        string(REGEX REPLACE "-console$" "" _umicom_native_target
            "${_umicom_executable}")
        # OS has an established console target without a -console suffix.
        if(_umicom_slug STREQUAL "os")
            set(_umicom_native_target "umicom-os-control-centre-gtk")
        endif()
        if(TARGET "${_umicom_native_target}")
            message(FATAL_ERROR
                "Native target ${_umicom_native_target} already belongs to another frontend")
        endif()

        add_executable("${_umicom_native_target}"
            "${CMAKE_CURRENT_SOURCE_DIR}/framework/examples/product_workstation_main.c")
        target_compile_definitions("${_umicom_native_target}" PRIVATE
            UMICOM_PRODUCT_APPLICATION_ID="${_umicom_id}"
            UMICOM_PRODUCT_TITLE="${_umicom_title}")
        target_link_libraries("${_umicom_native_target}" PRIVATE
            "${_umicom_module_target}" Umicom::ui_gtk4)
        umicom_apply_warnings("${_umicom_native_target}")
        umicom_apply_sanitizers("${_umicom_native_target}")

        get_property(CMAKE_INSTALL_DEFAULT_COMPONENT_NAME
            DIRECTORY "${_umicom_directory}"
            PROPERTY UMICOM_APPLICATION_INSTALL_COMPONENT)
        umicom_apply_application_branding(
            TARGET "${_umicom_native_target}"
            PRODUCT_NAME "${_umicom_title}"
            INTERNAL_NAME "${_umicom_native_target}"
            APPLICATION_ID "${_umicom_id}.gtk"
            RESOURCE_ROOT "${UMICOM_FRAMEWORK_RESOURCE_ROOT}"
            DESKTOP_ENTRY WINDOWS_GUI)
        install(TARGETS "${_umicom_native_target}"
            RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
        add_dependencies(umicom-desktop-products "${_umicom_native_target}")
    endforeach()
endfunction()
