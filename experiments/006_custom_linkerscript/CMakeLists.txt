
add_executable(006_custom_linkerscript
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/init.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${CMAKE_CURRENT_LIST_DIR}/reset_handler.s
	${CMAKE_CURRENT_LIST_DIR}/system.cpp
	${CMAKE_CURRENT_LIST_DIR}/vector_table.cpp
)

target_include_directories(006_custom_linkerscript
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
)

target_link_libraries(006_custom_linkerscript
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/memory_itcm.ld
	${CMAKE_CURRENT_LIST_DIR}/sections.ld
)

bob_firmware_image(006_custom_linkerscript)

target_compile_options(006_custom_linkerscript
	PRIVATE
		# from 002_st_cpp_options
		$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
		$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
		-fno-unwind-tables
		$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
)

target_link_options(006_custom_linkerscript
	PRIVATE
		# from 003_st_nostartfiles
		-nostartfiles
		# from 006_custom_linkerscript
		--specs=nosys.specs				# Use stubs for C syscalls.
		-nostdlib
)
