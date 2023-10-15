set(CMAKE_SYSTEM_NAME Generic)
set(CMAKE_SYSTEM_PROCESSOR arm)

#
# Find my compiler
#
find_program(CROSS_GCC_PATH "arm-none-eabi-gcc"
	PATH
		"${CMAKE_SOURCE_DIR}/external/src/arm-gnu-toolchain-12.2.mpacbti-rel1-x86_64-arm-none-eabi/bin"
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
# Note: specific settings are configurable, hence are defined in
# `bob_options.cmake`. For example: `mfloat-abi`
#
set(ARM_API
	-mcpu=cortex-m7					# ARM Cortex-M7 CPU.
	-mfpu=fpv5-d16					# FPU use FPv5 instructions.
	-mthumb							# Generate Thumb instructions.
	-mabi=aapcs						# Use 'ARM Architecture Procedure Calling Standard' ABI.
)

add_compile_options(
	${ARM_API}
	--specs=nosys.specs				# Use stubs for C syscalls.
	-ffunction-sections				# Place each function into it's own section.
	-fdata-sections					# Place each data element into it's own section.
	-g								# Always add debug information
	-gdwarf-5
)

add_link_options(
	${ARM_API}
	-nostartfiles
	-nostdlib
	--specs=nosys.specs				# Use stubs for C syscalls.
	LINKER:--gc-sections			# Garbage collection using the unique function and data sections.
	LINKER:--build-id=uuid			# Generate a unique identiefier for each build and store it in a specific section (.note.gnu.build-id).
	LINKER:--cref					# Generate a cross reference table in the MAP file, listing symbols and their source file(s).
	LINKER:--no-warn-rwx-segment
)

add_compile_definitions(
	STM32F767xx						# Define the specific MCU.
)

#todo: what if I want to override these?
set(LINKER_SCRIPTS
	${CMAKE_CURRENT_LIST_DIR}/../../linkerscripts/stm32f7/memory.ld
	${CMAKE_CURRENT_LIST_DIR}/../../linkerscripts/stm32f7/sections.ld
)
