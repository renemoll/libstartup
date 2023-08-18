
add_library(cortex_m_gloss OBJECT
	reset_handler.s
	syscall.c
	vector_table.cpp
)
target_link_libraries(cortex_m_gloss
	PRIVATE
		bob_interface
		stm32_cmsis
)
target_include_directories(cortex_m_gloss
	PUBLIC
		${PROJECT_BINARY_DIR}
		${PROJECT_SOURCE_DIR}/include
)
