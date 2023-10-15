
add_executable(libstartup_example
	main.cpp
	timeout.cpp
)

target_link_libraries(libstartup_example
	PRIVATE
		bob_interface
		stm32_f7
		stm32_hal
		cortex_m
)
bob_firmware_image(libstartup_example)
