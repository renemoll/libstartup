
add_library(util
	cyclecounter.c
)
target_link_libraries(util
	PRIVATE
		bob_interface
		stm32_cmsis
)
set_source_files_properties(cyclecounter.c
	PROPERTIES
		COMPILE_FLAGS "-Wno-sign-conversion"
)
target_include_directories(util
	PUBLIC
		${PROJECT_SOURCE_DIR}/include
)


add_subdirectory(stm32f7)

add_subdirectory(libstartup)
add_subdirectory(libstartup_tiny)
add_subdirectory(libstartup_inline)

add_subdirectory(gloss)
add_subdirectory(st)