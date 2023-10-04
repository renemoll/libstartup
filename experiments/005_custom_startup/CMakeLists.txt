
add_executable(005_custom_startup
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/init.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${CMAKE_CURRENT_LIST_DIR}/reset_handler.s
	${CMAKE_CURRENT_LIST_DIR}/system.cpp
	${CMAKE_CURRENT_LIST_DIR}/vector_table.cpp
)

target_include_directories(005_custom_startup
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
)

target_link_libraries(005_custom_startup
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/../001_st_baseline/STM32F767ZITx_FLASH.ld
)

bob_firmware_image(005_custom_startup)

target_compile_options(005_custom_startup
	PRIVATE
		# from 002_st_cpp_options
		$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
		$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
		-fno-unwind-tables
		$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
)

target_link_options(005_custom_startup
	PRIVATE
		# from 003_st_nostartfiles
		-nostartfiles
		# from 005_custom_startup
		--specs=nosys.specs				# Use stubs for C syscalls.
		-nostdlib
)
