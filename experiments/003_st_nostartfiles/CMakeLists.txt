
add_executable(003_st_nostartfiles
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/init.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/system_stm32f7xx.c
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/gcc/startup_stm32f767xx.s
)

target_include_directories(003_st_nostartfiles
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
)

target_link_libraries(003_st_nostartfiles
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/../001_st_baseline/STM32F767ZITx_FLASH.ld
)

bob_firmware_image(003_st_nostartfiles)

target_compile_options(003_st_nostartfiles
	PRIVATE
		# from 002_st_cpp_options
		$<$<COMPILE_LANGUAGE:CXX>:-fno-exceptions>
		$<$<COMPILE_LANGUAGE:CXX>:-fno-rtti>
		-fno-unwind-tables
		$<$<COMPILE_LANGUAGE:CXX>:-fno-use-cxa-atexit>
)

target_link_options(003_st_nostartfiles
	PRIVATE
		-nostartfiles
)
