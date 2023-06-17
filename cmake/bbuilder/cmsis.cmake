
add_library(CMSIS INTERFACE)
target_include_directories(CMSIS
	INTERFACE
	"${libstartup_SOURCE_DIR}/external/src/CMSIS_5.git/CMSIS/Core/Include"
)

