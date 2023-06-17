
add_executable(libstartup_example
#	${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_ll_gpio.c
	main.cpp
)

target_link_libraries(libstartup_example
PRIVATE
	bob_interface
	STM32F7
	STM32_HAL
	CORTEXM
)
bob_firmware_image(libstartup_example)
