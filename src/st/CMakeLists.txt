
#
# Create an "object" library to preserve the weak symbols used for IRQ handlers.
#
add_library(cortex_m_st OBJECT
	# ${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/gcc/startup_stm32f767xx.s
	startup_stm32f767xx.s
	${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/system_stm32f7xx.c
)

# # Remove `pedantic` as we call `main`
set_source_files_properties(${PROJECT_SOURCE_DIR}/external/src/cmsis_device_f7.git/Source/Templates/system_stm32f7xx.c
	PROPERTIES
		COMPILE_FLAGS "-Wno-pedantic -Wno-sign-conversion"
)

target_link_libraries(cortex_m_st
	PRIVATE
		bob_interface
		stm32_cmsis
	PUBLIC
		util
)
target_include_directories(cortex_m_st
	PUBLIC
		${PROJECT_BINARY_DIR}
		${PROJECT_SOURCE_DIR}/include
)
