
#
# Create an "object" library to preserve the weak symbols used for IRQ handlers.
#
add_library(cortex_m OBJECT
	reset_handler.s
	system.cpp
)

# Remove `pedantic` as we call `main`
set_source_files_properties(system.cpp PROPERTIES COMPILE_FLAGS "-Wno-pedantic -Wno-useless-cast -Wno-sign-conversion -Wno-old-style-cast")

# target_compile_options(cortex_m
# 	PRIVATE
# 		-fno-tree-loop-distribute-patterns
# )
target_link_libraries(cortex_m
	PRIVATE
		bob_interface
		stm32_cmsis
	PUBLIC
		util
)
target_include_directories(cortex_m
	PUBLIC
		${PROJECT_BINARY_DIR}
		${PROJECT_SOURCE_DIR}/include
)
