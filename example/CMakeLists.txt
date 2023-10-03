
# set(VARIANTS "flash" "itcm")
# foreach(VARIANT ${VARIANTS})
# 	set(LINKER_SCRIPTS
# 		${CMAKE_CURRENT_LIST_DIR}/../linkerscripts/stm32f7/memory_${VARIANT}.ld
# 		${CMAKE_CURRENT_LIST_DIR}/../linkerscripts/stm32f7/sections.ld
# 	)

# 	add_executable(libstartup_example_${VARIANT}
# 		main.cpp
# 	)

# 	target_link_libraries(libstartup_example_${VARIANT}
# 		PRIVATE
# 			bob_interface
# 			stm32_f7
# 			stm32_hal
# 			cortex_m
# 	)
# 	bob_firmware_image(libstartup_example_${VARIANT})

# 	#
# 	# inlne
# 	#

# 	add_executable(libstartup_inline_example_${VARIANT}
# 		main.cpp
# 	)

# 	target_link_libraries(libstartup_inline_example_${VARIANT}
# 		PRIVATE
# 			bob_interface
# 			stm32_f7
# 			stm32_hal
# 			cortex_m_inline
# 	)
# 	bob_firmware_image(libstartup_inline_example_${VARIANT})

# 	#
# 	# tiny
# 	#

# 	add_executable(libstartup_tiny_example_${VARIANT}
# 		main.cpp
# 	)

# 	target_link_libraries(libstartup_tiny_example_${VARIANT}
# 		PRIVATE
# 			bob_interface
# 			stm32_f7
# 			stm32_hal
# 			cortex_m_tiny
# 	)
# 	bob_firmware_image(libstartup_tiny_example_${VARIANT})


# 	#
# 	# st
# 	#

# 	add_executable(libstartup_st_example_${VARIANT}
# 		main.cpp
# 	)
# 	target_compile_definitions(libstartup_st_example_${VARIANT}
# 		PRIVATE
# 			SYS_CORE_CLK
# 	)
# 	get_target_property(libstartup_st_example_LINK_OPTIONS libstartup_st_example_${VARIANT} LINK_OPTIONS)
# 	list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "-nostartfiles")
# 	list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "-nostdlib")
# 	list(REMOVE_ITEM libstartup_st_example_LINK_OPTIONS "--specs=nosys.specs")
# 	set_target_properties(libstartup_st_example_${VARIANT} PROPERTIES LINK_OPTIONS "${libstartup_st_example_LINK_OPTIONS}")
# 	target_compile_options(libstartup_st_example_${VARIANT}
# 		PUBLIC
# 			--specs=nano.specs
# 	)
# 	target_link_options(libstartup_st_example_${VARIANT}
# 		PUBLIC
# 			--specs=nano.specs
# 	)
# 	target_link_libraries(libstartup_st_example_${VARIANT}
# 		PRIVATE
# 			bob_interface
# 			stm32_hal
# 			cortex_m_st
# 	)

# 	bob_firmware_image(libstartup_st_example_${VARIANT})

# 	#
# 	# gloss
# 	#

# 	add_executable(libstartup_gloss_example_${VARIANT}
# 		main.cpp
# 	)

# 	get_target_property(libstartup_gloss_example_LINK_OPTIONS libstartup_gloss_example_${VARIANT} LINK_OPTIONS)
# 	list(REMOVE_ITEM libstartup_gloss_example_LINK_OPTIONS "-nostartfiles")
# 	list(REMOVE_ITEM libstartup_gloss_example_LINK_OPTIONS "-nostdlib")
# 	list(REMOVE_ITEM libstartup_gloss_example_LINK_OPTIONS "--specs=nosys.specs")
# 	set_target_properties(libstartup_gloss_example_${VARIANT} PROPERTIES LINK_OPTIONS "${libstartup_gloss_example_LINK_OPTIONS}")
# 	target_link_options(libstartup_gloss_example_${VARIANT}
# 		PUBLIC
# 			--specs=nano.specs
# 	)
# 	target_link_libraries(libstartup_gloss_example_${VARIANT}
# 		PRIVATE
# 			bob_interface
# 			stm32_hal
# 			cortex_m_gloss
# 	)

# 	bob_firmware_image(libstartup_gloss_example_${VARIANT})
# endforeach()

add_executable(startup_example
	sections.cpp
	# foo.cpp
	# cabi.c
	# cxxabi.cpp
	init.cpp
	# new_delete.cpp
	timeout.cpp
)

# get_target_property(sections_LINK_OPTIONS sections LINK_OPTIONS)
# list(REMOVE_ITEM sections_LINK_OPTIONS "-nostartfiles")
# list(REMOVE_ITEM sections_LINK_OPTIONS "-nostdlib")
# list(REMOVE_ITEM sections_LINK_OPTIONS "--specs=nosys.specs")
# set_target_properties(sections PROPERTIES LINK_OPTIONS "${sections_LINK_OPTIONS}")

# get_target_property(sections_COMPILE_OPTIONS sections COMPILE_OPTIONS)
# list(REMOVE_ITEM sections_COMPILE_OPTIONS "--specs=nosys.specs")
# set_target_properties(sections PROPERTIES COMPILE_OPTIONS "${sections_COMPILE_OPTIONS}")

# target_compile_options(sections
# PUBLIC
	# --specs=nano.specs
# )

# target_link_options(sections
# PUBLIC
	# --specs=nano.specs
	# -startfiles
	# -stdlib
# )

target_link_libraries(startup_example
PRIVATE
	# bob_interface
	stm32_hal
	cortex_m_st
)
bob_firmware_image(startup_example)
