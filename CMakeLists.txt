cmake_minimum_required(VERSION 3.12)

project(libstartup
    VERSION 0.1.0
	LANGUAGES CXX C ASM
)

if(CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)
	option(libstartup_examples "Build examples" ON)

	set(CMAKE_C_STANDARD 17)
	set(CMAKE_C_STANDARD_REQUIRED ON)
	set(CMAKE_C_EXTENSIONS OFF)
	set(CMAKE_CXX_STANDARD 20)
	set(CMAKE_CXX_STANDARD_REQUIRED ON)
	set(CMAKE_CXX_EXTENSIONS OFF)

    set(CMAKE_CXX_VISIBILITY_PRESET hidden)
    set(CMAKE_VISIBILITY_INLINES_HIDDEN YES)

	add_compile_definitions(STM32F767xx)
endif()

#
# Gather the toolchain configuration
#

set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})
set(CMAKE_MODULE_PATH "${PROJECT_SOURCE_DIR}/cmake/bbuilder" ${CMAKE_MODULE_PATH})
include(bob)

#
# Configure the applications
#

add_subdirectory(src)

if (${libstartup_examples})
	add_subdirectory(example)
endif()
