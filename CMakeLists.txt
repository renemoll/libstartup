cmake_minimum_required(VERSION 3.12)

#
# [BOB] This is needed right here to download the toolchain files
#       before they are used within a project.
#
list(PREPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
find_package(Bob REQUIRED)

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

	# TODO: make this part of bob-cmake?
	add_compile_definitions(${MCU})
endif()

#
# Gather the toolchain configuration
#

include(bob)

if (CMAKE_CROSSCOMPILING)
	# TODO: make this part of bob-cmake?
	include(cmsis)
	include(stm32)
endif()

#
# Configure the applications
#

add_subdirectory(src)

if (${libstartup_examples})
	add_subdirectory(example)
endif()
