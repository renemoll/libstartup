
#
# Create an "object" library to preserve the weak symbols used for IRQ handlers.
#

add_library(STM32F7 OBJECT
#	${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Src/stm32f7xx_ll_utils.c
	vector_table.cpp
)
target_link_libraries(STM32F7
	PRIVATE
		bob_interface
)
# target_include_directories(STM32F7
# 	PUBLIC
# 		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Core/Include
# 		${stm32cubef7_SOURCE_DIR}/Drivers/CMSIS/Device/ST/STM32F7xx/Include
# 		${stm32cubef7_SOURCE_DIR}/Drivers/STM32F7xx_HAL_Driver/Inc
# )
# target_compile_features(stm32f7_system
# 	PRIVATE
# 		cxx_relaxed_constexpr
# 		cxx_std_20
# )
