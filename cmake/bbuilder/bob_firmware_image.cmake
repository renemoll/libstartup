
function(bob_firmware_image target)
	target_link_options(${target} PRIVATE
		LINKER:--print-memory-usage
		LINKER:-Map=$<TARGET_FILE:${target}>.map
	)

	foreach(LDFILE ${LINKER_SCRIPTS})
		target_link_options(${target} PRIVATE
			-T${LDFILE}
		)
	endforeach()

	set_target_properties(${target}
		PROPERTIES
			SUFFIX .elf
		LINK_DEPENDS
			"${LINKER_SCRIPTS}"
	)

	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${CMAKE_OBJCOPY} -O ihex $<TARGET_FILE:${target}>
			${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.hex
	)

	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${CMAKE_OBJCOPY} -I elf32-littlearm -O binary $<TARGET_FILE:${target}>
			${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.bin
	)

	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${TOOLCHAIN_SIZE} --format=berkeley $<TARGET_FILE:${target}>
			> ${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.bsz
	)
	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${TOOLCHAIN_SIZE} --format=sysv -x $<TARGET_FILE:${target}>
			>${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.ssz
	)

	add_custom_command(
		TARGET ${target}
		POST_BUILD
		COMMAND ${TOOLCHAIN_OBJDUMP} -d -S $<TARGET_FILE:${target}>
			>${CMAKE_CURRENT_BINARY_DIR}/$<TARGET_NAME:${target}>.dasm
	)
endfunction()