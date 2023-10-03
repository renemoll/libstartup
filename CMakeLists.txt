cmake_minimum_required(VERSION 3.12)

project(libstartup VERSION 0.1)
enable_language(CXX C ASM)

# if (CMAKE_SOURCE_DIR STREQUAL PROJECT_SOURCE_DIR)
	# option(libstartup_examples "Build examples" ON)
# else()
	# option(libstartup_examples "Build examples" OFF)
# endif()

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#
# Gather the toolchain configuration
#

# list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/bbuilder")
# include(bob)

include(cmsis)
include(stm32)
include(bob_firmware_image)

#
# Configure the applications
#

# add_subdirectory(src)

# if (${libstartup_examples})
	# add_subdirectory(example)
# endif()

add_subdirectory(experiments)
