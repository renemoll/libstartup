cmake_minimum_required(VERSION 3.12)

project(libstartup)
enable_language(CXX C ASM)

set(CMAKE_C_STANDARD 99)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

#
# Gather the toolchain configuration
#

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake")
list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/bbuilder")
include(bob)

set(USE_HW_FPU OFF CACHE BOOL "Disable FPU" FORCE)

#
# Configure the applications
#

add_subdirectory(src)
add_subdirectory(example)
