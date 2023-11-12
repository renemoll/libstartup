
if (CMAKE_CROSSCOMPILING)
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

	set(LINKER_SCRIPTS
		${CMAKE_CURRENT_LIST_DIR}/../linkerscripts/stm32f7/memory.ld
		${CMAKE_CURRENT_LIST_DIR}/../linkerscripts/stm32f7/sections.ld
	)

	bob_firmware_image(libstartup_example)
endif()
