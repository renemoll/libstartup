
add_executable(008_custom_inline
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/init.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/reset_handler.s
	${CMAKE_CURRENT_LIST_DIR}/system.cpp
	${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/vector_table.cpp
)

target_include_directories(008_custom_inline
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
		${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/
)

target_link_libraries(008_custom_inline
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/memory_itcm.ld
	${CMAKE_CURRENT_LIST_DIR}/../006_custom_linkerscript/sections.ld
)

bob_firmware_image(008_custom_inline)

target_compile_options(008_custom_inline
	PRIVATE
		# from 002_st_cpp_options
		$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
		$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
		-fno-unwind-tables
		$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
		# from 007_custom_tiny_memset
		-fno-tree-loop-distribute-patterns
)

target_link_options(008_custom_inline
	PRIVATE
		# from 003_st_nostartfiles
		-nostartfiles
		# from 007_custom_tiny_memset
		--specs=nosys.specs				# Use stubs for C syscalls.
		-nostdlib
)
