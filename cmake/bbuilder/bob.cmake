#
# Meet Bob: my collection of build tools
#

cmake_minimum_required(VERSION 3.12 FATAL_ERROR)

function(bob_info)
	message(STATUS "[BOB] Info: ${ARGN}")
endfunction()

function(bob_error)
	message(FATAL_ERROR "[BOB] Error: ${ARGN}")
endfunction()

#
# Ensure an out of source build folder.
#

function(ensure_out_of_source_build)
	get_filename_component(srcdir "${CMAKE_SOURCE_DIR}" REALPATH)
	get_filename_component(bindir "${CMAKE_BINARY_DIR}" REALPATH)

	if("${srcdir}" STREQUAL "${bindir}")
		bob_error("in-source build detected.")
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
	bob_info("no build type selected, defaulting to 'Release'.")
	set(CMAKE_BUILD_TYPE "Release" CACHE STRING "Build configuration" FORCE)
endif()

bob_info("CMAKE_BUILD_TYPE is ${CMAKE_BUILD_TYPE}")

#
# Generate a version header
#
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

# target_compile_features(bob_interface
# 	INTERFACE
# 		cxx_std_20
# )

#
# Cortex-M generic templates
#

include(cmsis)
include(stm32)

#
# Generate a option header
#
configure_file(cmake/config_options.h.in config_options.h)


# if(NOT APPLE)
# 	set(CMAKE_INSTALL_RPATH $ORIGIN)
# endif()
