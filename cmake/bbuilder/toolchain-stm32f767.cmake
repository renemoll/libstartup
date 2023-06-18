set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

#
# Find my compiler
#
find_program(CROSS_GCC_PATH "arm-none-eabi-gcc"
	PATH
		"${libstartup_SOURCE_DIR}/external/src/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin"
		"/opt/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin"
	NO_DEFAULT_PATH)
get_filename_component(TOOLCHAIN_PATH ${CROSS_GCC_PATH} PATH)

set(CMAKE_C_COMPILER   ${TOOLCHAIN_PATH}/arm-none-eabi-gcc)
set(CMAKE_CXX_COMPILER ${TOOLCHAIN_PATH}/arm-none-eabi-g++)
set(TOOLCHAIN_SIZE     ${TOOLCHAIN_PATH}/arm-none-eabi-size    CACHE STRING "arm-none-eabi-size")
set(TOOLCHAIN_OBJDUMP  ${TOOLCHAIN_PATH}/arm-none-eabi-objdump CACHE STRING "arm-none-eabi-objdump")

# CMAKE configuration
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)

#
# Cortex-M7 specific compiler configuration
#
set(ARM_API
	-mcpu=cortex-m7					# ARM Cortex-M7 CPU.
	-mfpu=fpv5-d16					# FPU use FPv5 instructions.
	-mthumb							# Generate Thumb instructions.
	-mabi=aapcs						# Use 'ARM Architecture Procedure Calling Standard' ABI.
)

if(${BOB_USE_HW_FPU})
	list(APPEND ARM_API
		-mfloat-abi=hard			# FPU ABI: hard(ware).
	)
else()
	list(APPEND ARM_API
		-mfloat-abi=soft			# FPU ABI: soft(ware).
	)
endif()

add_compile_options(
	${ARM_API}
	# --specs=nano.specs			# newlib nano.
	-ffunction-sections				# Place each function into it's own section.
	-fdata-sections					# Place each data element into it's own section.
	$<$<CONFIG:DEBUG>:-gdwarf-5>	# Generate debug information in DWARF format.
)

add_link_options(
	${ARM_API}
	-nostartfiles
	# -nostdlib
	# --specs=nano.specs
	--specs=nosys.specs				# Use stubs for C syscalls.
	# -–specs rdimon.specs			# Enable semihosting.
	LINKER:--gc-sections			# Garbage collection using the unique function and data sections.
	LINKER:--build-id=uuid			# Generate a unique identiefier for each build and store it in a specific section (.note.gnu.build-id).
	LINKER:--cref					# Generate a cross reference table in the MAP file, listing symbols and their source file(s).
)

add_compile_definitions(
	STM32F767xx						# Define the specific MCU.
)

#
# Helper function
#
function(bob_firmware_image target)
	set(LINKER_SCRIPTS
		${CMAKE_SOURCE_DIR}/linkerscripts/stm32f7/memory.ld
		${CMAKE_SOURCE_DIR}/linkerscripts/stm32f7/sections.ld
	)

	target_link_options(${target} PRIVATE
		-T${CMAKE_SOURCE_DIR}/linkerscripts/stm32f7/memory.ld
		-T${CMAKE_SOURCE_DIR}/linkerscripts/stm32f7/sections.ld
		LINKER:--print-memory-usage
		LINKER:-Map=$<TARGET_FILE:${target}>.map
	)

	set_target_properties(${target}
		PROPERTIES
			SUFFIX .elf
		LINK_DEPENDS "${LINKER_SCRIPTS}"
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