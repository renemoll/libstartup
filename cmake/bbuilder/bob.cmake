#
# Meet Bob: my collection of build tools
#

cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

#
# Ensure an out of source build folder.
#

function(ensure_out_of_source_build)
	get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
	get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

	if("${srcdir}" STREQUAL "${bindir}")
		message(FATAL_ERROR "\n
			In-source build detected!\
			Generate an out of source build with:\
			\
			cmake -S . -B build")
	endif()
endfunction()
ensure_out_of_source_build()

#
# Generate compile_commands.json for Clang based tools.
# Note: this does not require a clang based toolchain.
#

set(CMAKE_EXPORT_COMPILE_COMMANDS On)

#
# Ensure a build configuration.
#

if(NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
	message(STATUS "Defaulting build type to 'RelWithDebInfo'.")
	set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Build configuration" FORCE)
endif()

message(STATUS "CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

#
# Generate a option and version headers
#
configure_file(cmake/config_options.h.in config_options.h)
configure_file(cmake/version.h.in version.h)

#
# Project template
#

include(bob_compiler)
include(bob_options)
include(bob_firmware_image)

add_library(bob_interface INTERFACE)
bob_configure_compiler_warnings(bob_interface)
bob_configure_compiler_codegen(bob_interface)
bob_configure_options(bob_interface)

target_compile_features(bob_interface
	INTERFACE
		cxx_std_20
)

#
# Cortex-M generic templates
#

include(cmsis)
include(stm32)
