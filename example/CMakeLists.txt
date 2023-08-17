
add_executable(libstartup_example
	main.cpp
)

target_link_libraries(libstartup_example
	PRIVATE
		bob_interface
		stm32_f7
		stm32_hal
		cortex_m
)
bob_firmware_image(libstartup_example)

#
# inlne
#

add_executable(libstartup_inline_example
	main.cpp
)

target_link_libraries(libstartup_inline_example
	PRIVATE
		bob_interface
		stm32_f7
		stm32_hal
		cortex_m_inline
)
bob_firmware_image(libstartup_inline_example)

#
# tiny
#

add_executable(libstartup_tiny_example
	main.cpp
)

target_link_libraries(libstartup_tiny_example
	PRIVATE
		bob_interface
		stm32_f7
		stm32_hal
		cortex_m_tiny
)
bob_firmware_image(libstartup_tiny_example)


#
# st
#
# WARNING: make sure this is the last target as a global variable is changed.
#

add_executable(libstartup_st_example
	main.cpp
)
target_compile_definitions(libstartup_st_example
	PRIVATE
		SYS_CORE_CLK
)
get_target_property(libstartup_st_example_LINK_OPTIONS libstartup_st_example LINK_OPTIONS)
list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "-nostartfiles")
list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "-nostdlib")
list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "--specs=nosys.specs")
list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "LINKER:--build-id=uuid")
set_target_properties(libstartup_st_example PROPERTIES LINK_OPTIONS "${libstartup_st_example_LINK_OPTIONS}")
target_link_options(libstartup_st_example
	PUBLIC
	--specs=nano.specs
)
target_link_libraries(libstartup_st_example
	PRIVATE
		bob_interface
		stm32_hal
		cortex_m_st
)

set(LINKER_SCRIPTS ${PROJECT_SOURCE_DIR}/src/st/STM32F767ZITx_FLASH.ld)
bob_firmware_image(libstartup_st_example)
