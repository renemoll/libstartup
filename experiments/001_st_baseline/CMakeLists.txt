
add_executable(001_st_baseline
	${CMAKE_CURRENT_LIST_DIR}/../common/main.cpp
	${CMAKE_CURRENT_LIST_DIR}/../common/timeout.cpp
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/system_stm32f7xx.c
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/gcc/startup_stm32f767xx.s
)

target_include_directories(001_st_baseline
	PRIVATE	
		${CMAKE_CURRENT_LIST_DIR}/../common/
)

target_link_libraries(001_st_baseline
	PRIVATE
		stm32_hal
)

set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/STM32F767ZITx_FLASH.ld
)

bob_firmware_image(001_st_baseline)
