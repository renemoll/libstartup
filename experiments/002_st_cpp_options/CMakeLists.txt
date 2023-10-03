
add_executable(002_st_cpp_options
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/system_stm32f7xx.c
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/gcc/startup_stm32f767xx.s
)

target_include_directories(002_st_cpp_options
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
)

target_link_libraries(002_st_cpp_options
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/../001_st_baseline/STM32F767ZITx_FLASH.ld
)

bob_firmware_image(002_st_cpp_options)

target_compile_options(002_st_cpp_options
	PRIVATE
		$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
		$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
		-fno-unwind-tables
		$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
)
