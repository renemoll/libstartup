
add_library(cmsis INTERFACE)
target_include_directories(cmsis
	INTERFACE
		"${CMAKE_SOURCE_DIR}/external/src/CMSIS_5.git/CMSIS/Core/Include"
)

