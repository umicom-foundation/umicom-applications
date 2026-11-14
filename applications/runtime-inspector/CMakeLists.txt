# -----------------------------------------------------------------------------
# Umicom Applications
# File: applications/runtime-inspector/CMakeLists.txt
# PURPOSE: Build a thin command-line consumer of Framework PE import inspection.
# EDUCATIONAL OVERVIEW: Parsing and ownership stay in Framework; this application
# only reads one selected file and presents the resulting dependency names.
# AUTHOR AND ORGANISATION: Sammy Hegab, Umicom Foundation
# LICENCE: MIT
# -----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.25)
project(UmicomRuntimeInspector LANGUAGES C)
include(CTest)
set(UMICOM_FRAMEWORK_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/../../framework" CACHE PATH "Canonical Framework source")
include("${UMICOM_FRAMEWORK_SOURCE_DIR}/cmake/UmicomPeImports.cmake")
add_executable(umicom-runtime-inspect main.c)
target_link_libraries(umicom-runtime-inspect PRIVATE Umicom::pe_imports)
set_target_properties(umicom-runtime-inspect PROPERTIES C_STANDARD 23 C_STANDARD_REQUIRED YES C_EXTENSIONS NO)
if(CMAKE_C_COMPILER_ID MATCHES "GNU|Clang")
    target_compile_options(umicom-runtime-inspect PRIVATE -Wall -Wextra -Wpedantic -Wconversion -Wshadow -Werror)
endif()
install(TARGETS umicom-runtime-inspect RUNTIME DESTINATION bin)
if(BUILD_TESTING)
    add_subdirectory("${UMICOM_FRAMEWORK_SOURCE_DIR}/tests/pe_imports" pe-import-tests)
endif()
