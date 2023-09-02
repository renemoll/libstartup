
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
set_target_properties(libstartup_st_example PROPERTIES LINK_OPTIONS "${libstartup_st_example_LINK_OPTIONS}")
target_compile_options(libstartup_st_example
	PUBLIC
		--specs=nano.specs
)
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

bob_firmware_image(libstartup_st_example)

#
# gloss
#

add_executable(libstartup_gloss_example
	main.cpp
)

get_target_property(libstartup_gloss_example_LINK_OPTIONS libstartup_gloss_example LINK_OPTIONS)
list(REMOVE_ITEM libstartup_gloss_example_LINK_OPTIONS "-nostartfiles")
list(REMOVE_ITEM libstartup_gloss_example_LINK_OPTIONS "-nostdlib")
list(REMOVE_ITEM libstartup_gloss_example_LINK_OPTIONS "--specs=nosys.specs")
set_target_properties(libstartup_gloss_example PROPERTIES LINK_OPTIONS "${libstartup_gloss_example_LINK_OPTIONS}")
target_link_options(libstartup_gloss_example
	PUBLIC
		--specs=nano.specs
)
target_link_libraries(libstartup_gloss_example
	PRIVATE
		bob_interface
		stm32_hal
		cortex_m_gloss
)

bob_firmware_image(libstartup_gloss_example)
