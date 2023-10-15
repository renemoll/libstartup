
add_executable(011_libgloss
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${CMAKE_CURRENT_LIST_DIR}/reset_handler.s
	${CMAKE_CURRENT_LIST_DIR}/syscall.c
	${CMAKE_CURRENT_LIST_DIR}/system.cpp
	${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/vector_table.cpp
)

target_include_directories(011_libgloss
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
		${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/
)

target_link_libraries(011_libgloss
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/memory_itcm.ld
	${CMAKE_CURRENT_LIST_DIR}/sections.ld
	${CMAKE_CURRENT_LIST_DIR}/compatability.ld
)

bob_firmware_image(011_libgloss)

target_compile_options(011_libgloss
	PRIVATE
		# from 002_st_cpp_options
		$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
		$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
		-fno-unwind-tables
		$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
		# from 007_custom_tiny_memset
		-fno-tree-loop-distribute-patterns
)

target_link_options(011_libgloss
	PRIVATE
		--specs=nano.specs
)
