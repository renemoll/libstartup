
#
# Create an "object" library to preserve the weak symbols used for IRQ handlers.
#
add_library(cortex_m OBJECT
	reset_handler.s
	system.cpp
)

# Remove `pedantic` as we call `main`
set_source_files_properties(system.cpp PROPERTIES COMPILE_FLAGS -Wno-pedantic)

target_link_libraries(cortex_m
	PRIVATE
		bob_interface
)
target_include_directories(cortex_m
	PUBLIC
		${PROJECT_BINARY_DIR}
		${PROJECT_SOURCE_DIR}/include
)

add_subdirectory(stm32f7)
