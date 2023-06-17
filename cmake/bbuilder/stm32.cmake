
add_library(STM32_CMSIS INTERFACE)
target_include_directories(STM32_CMSIS
	INTERFACE
	"${libstartup_SOURCE_DIR}/external/src/cmsis_device_f7.git/Include" # todo: rename to a common name (i.e. stm32_cmsis...)?
)
target_link_libraries(STM32_CMSIS
	INTERFACE
		CMSIS
)

add_library(STM32_HAL OBJECT
	"${libstartup_SOURCE_DIR}/external/src/stm32f7xx_hal_driver.git/Src/stm32f7xx_ll_gpio.c"
	# todo: extend
)
target_include_directories(STM32_HAL
	PUBLIC
		"${libstartup_SOURCE_DIR}/external/src/stm32f7xx_hal_driver.git/Inc" # todo: rename to a common name (i.e. stm32_hal...)?
)
target_compile_definitions(STM32_HAL
	PUBLIC
		USE_FULL_LL_DRIVER
)
#todo: this leaks... NOK...
target_compile_options(STM32_HAL
	INTERFACE
		$<$<COMPILE_LANGUAGE:CXX>:-Wno-volatile>
		$<$<COMPILE_LANGUAGE:CXX>:-Wno-useless-cast>
		-Wno-unused-parameter
		$<$<COMPILE_LANGUAGE:CXX>:-Wno-old-style-cast>
		-Wno-pedantic
		$<$<COMPILE_LANGUAGE:CXX>:-Wno-sign-conversion>
)
target_link_libraries(STM32_HAL
	PUBLIC
		STM32_CMSIS
)