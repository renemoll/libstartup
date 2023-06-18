
#
# Create an "object" library to preserve the weak symbols used for IRQ handlers.
#
add_library(CORTEXM OBJECT
	reset_handler.s
	system.cpp
)
target_link_libraries(CORTEXM
	PRIVATE
		bob_interface
)
target_include_directories(CORTEXM
	PUBLIC
		${PROJECT_BINARY_DIR}
		${PROJECT_SOURCE_DIR}/include
# 		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Core/Include
# 		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Include
# 		${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Inc
)
# target_compile_features(stm32f7_system
# 	PRIVATE
# 		cxx_relaxed_constexpr
# 		cxx_std_20
# )

add_subdirectory(stm32f7)
