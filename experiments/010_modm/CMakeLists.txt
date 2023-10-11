
add_executable(010_modm
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${CMAKE_CURRENT_LIST_DIR}/cabi.c
	${CMAKE_CURRENT_LIST_DIR}/cxxabi.cpp
	${CMAKE_CURRENT_LIST_DIR}/no_heap.c
	${CMAKE_CURRENT_LIST_DIR}/reset_handler.s
	${CMAKE_CURRENT_LIST_DIR}/startup_platform.c
	${CMAKE_CURRENT_LIST_DIR}/startup.c
	${CMAKE_CURRENT_LIST_DIR}/vectors.c
	${CMAKE_CURRENT_LIST_DIR}/system.cpp
)

target_include_directories(010_modm
	PRIVATE
		${CMAKE_CURRENT_LIST_DIR}	
		${CMAKE_CURRENT_LIST_DIR}/../common/
)

target_link_libraries(010_modm
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/linkerscript.ld
)

bob_firmware_image(010_modm)

target_compile_options(010_modm
PRIVATE
	# from 002_st_cpp_options
	$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
	$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
	-fno-unwind-tables
	$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
	# from 007_custom_tiny_memset
	-fno-tree-loop-distribute-patterns
)

target_link_options(010_modm
PRIVATE
	# from 003_st_nostartfiles
	-nostartfiles
	# from 007_custom_tiny_memset
	--specs=nosys.specs				# Use stubs for C syscalls.
	-nostdlib
)
