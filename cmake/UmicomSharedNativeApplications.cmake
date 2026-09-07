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
    # file(STRINGS) alone does not register a configure input. Track each
    # already-discovered manifest so the next incremental build regenerates
    # native/headless target selection after an edit; this does not discover
    # new modules or change the existing application-discovery policy.
    set_property(DIRECTORY APPEND PROPERTY CMAKE_CONFIGURE_DEPENDS "${manifest}")
    # Mirror only the identity subset of the C parser. Schema chooses either
    # direct application children (.v1) or existing generated flat fields (/v1).
    # Do not promote a metadata mapping or a late schema into launch identity.
    file(STRINGS "${manifest}" _umicom_manifest_lines)
    set(_umicom_schema_seen FALSE)
    set(_umicom_flat_schema FALSE)
    set(_umicom_application_section FALSE)
    set(_umicom_field_indent "  ")
    set(_umicom_field_lines "")
    foreach(_umicom_manifest_line IN LISTS _umicom_manifest_lines)
        string(STRIP "${_umicom_manifest_line}" _umicom_trimmed_line)
        if(_umicom_trimmed_line STREQUAL "" OR _umicom_trimmed_line MATCHES "^#")
            continue()
        endif()
        if(_umicom_manifest_line MATCHES "^schema: *(.*)$")
            if(_umicom_schema_seen)
                message(FATAL_ERROR "Duplicate schema in ${manifest}")
            endif()
            set(_umicom_schema_seen TRUE)
            string(STRIP "${CMAKE_MATCH_1}" _umicom_manifest_schema)
            if(_umicom_manifest_schema STREQUAL "umicom.application/v1")
                set(_umicom_flat_schema TRUE)
                set(_umicom_field_indent "")
            elseif(NOT _umicom_manifest_schema STREQUAL "umicom.application.v1")
                message(FATAL_ERROR "Unsupported application schema in ${manifest}")
            endif()
            continue()
        endif()
        if(NOT _umicom_schema_seen)
            message(FATAL_ERROR "Application schema must precede identity in ${manifest}")
        endif()
        if(_umicom_flat_schema)
            if(_umicom_manifest_line MATCHES "^(application|framework):")
                message(FATAL_ERROR "Mixed flat/nested application identity in ${manifest}")
            endif()
            if(_umicom_manifest_line MATCHES "^[ \t]+${field}:")
                message(FATAL_ERROR "Indented flat ${field} declaration in ${manifest}")
            endif()
            if(_umicom_manifest_line MATCHES "^${field}: *")
                list(APPEND _umicom_field_lines "${_umicom_manifest_line}")
            endif()
        else()
            if(_umicom_manifest_line MATCHES "^application: *$")
                set(_umicom_application_section TRUE)
                continue()
            elseif(_umicom_manifest_line MATCHES "^[^ \t#][^:]*:")
                set(_umicom_application_section FALSE)
            endif()
            if(_umicom_manifest_line MATCHES "^${field}:")
                message(FATAL_ERROR "Flat ${field} inside nested schema in ${manifest}")
            endif()
            if(_umicom_application_section)
                if(_umicom_manifest_line MATCHES "^  ${field}: *")
                    list(APPEND _umicom_field_lines "${_umicom_manifest_line}")
                elseif(field MATCHES "^((native_|console_)?executable)$" AND
                       _umicom_manifest_line MATCHES "^[ \t]+${field}:")
                    message(FATAL_ERROR "Executable is not a direct application child in ${manifest}")
                endif()
            endif()
        endif()
    endforeach()
    if(NOT _umicom_schema_seen)
        message(FATAL_ERROR "Missing application schema in ${manifest}")
    endif()
    if(NOT _umicom_field_lines)
        if(ARGC GREATER 3 AND ARGV3 STREQUAL "OPTIONAL")
            set("${output_variable}" "" PARENT_SCOPE)
            return()
        endif()
        message(FATAL_ERROR "Missing ${field} in ${manifest}")
    endif()
    list(LENGTH _umicom_field_lines _umicom_field_count)
    if(NOT _umicom_field_count EQUAL 1)
        message(FATAL_ERROR "Duplicate ${field} in ${manifest}")
    endif()
    list(GET _umicom_field_lines 0 _umicom_field_value)
    string(REGEX REPLACE "^${_umicom_field_indent}${field}: *" "" _umicom_field_value
        "${_umicom_field_value}")
    string(STRIP "${_umicom_field_value}" _umicom_field_value)
    string(LENGTH "${_umicom_field_value}" _umicom_field_length)
    if(_umicom_field_length GREATER_EQUAL 256)
        message(FATAL_ERROR "Overlong ${field} in ${manifest}")
    endif()
    if(field MATCHES "^((native_|console_)?executable)$" AND
       (NOT _umicom_field_value MATCHES "^[A-Za-z0-9][A-Za-z0-9_.-]*$" OR
        _umicom_field_value MATCHES "[.]$"))
        message(FATAL_ERROR "Unsafe ${field} executable basename in ${manifest}")
    endif()
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
        # Each application declares its native basename explicitly. Legacy
        # console names, including OS, remain independent and are never guessed.
        umicom_native_manifest_field("${_umicom_manifest}" native_executable
            _umicom_native_target OPTIONAL)
        if(NOT _umicom_native_target)
            message(STATUS
                "No native executable declared for ${_umicom_relative_directory}; preserving its existing frontends")
            continue()
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
