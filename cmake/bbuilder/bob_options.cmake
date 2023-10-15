
option(BOB_USE_FPU "Enable Floating Point Unit (FPU) hardware ABI" ON)
option(BOB_USE_RTTI "Generate run-time type identification (RTTI)" OFF)
option(BOB_USE_EXCEPTIONS "Allow exceptions" OFF)
option(BOB_COMPILER_WARN_EVERYTHING "Enable -Weverything (Clang only)" OFF)
option(BOB_DEBUG_SYMBOLS "Embed debug symbols" ON)

add_compile_options(
	$<$<BOOL:${BOB_USE_FPU}>:-mfloat-abi=hard>			# FPU ABI: hard(ware).
	$<$<NOT:$<BOOL:${BOB_USE_FPU}>>:-mfloat-abi=soft>	# FPU ABI: soft(ware).
	$<$<BOOL:${BOB_DEBUG_SYMBOLS}>:-gdwarf-5>			# Generate debug information in DWARF format.
)

add_link_options(
	$<$<BOOL:${BOB_USE_FPU}>:-mfloat-abi=hard>			# FPU ABI: hard(ware).
	$<$<NOT:$<BOOL:${BOB_USE_FPU}>>:-mfloat-abi=soft>	# FPU ABI: soft(ware).
)

function(bob_configure_options target)
	if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
		target_compile_options(${target}
			INTERFACE
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<BOOL:${BOB_USE_RTTI}>>:-frtti>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<BOOL:${BOB_USE_RTTI}>>>:-fno-rtti>
				$<$<BOOL:${BOB_USE_EXCEPTIONS}>:-fexceptions>
				$<$<NOT:$<BOOL:${BOB_USE_EXCEPTIONS}>>:-fno-exceptions>
				$<$<NOT:$<BOOL:${BOB_USE_EXCEPTIONS}>>:-fno-unwind-tables>
		)

		target_compile_options(${target}
			INTERFACE
				$<$<AND:$<BOOL:${BOB_COMPILER_WARN_EVERYTHING}>,$<CXX_COMPILER_ID:Clang>>:-Weverything>
		)
	else()
		message(FATAL_ERROR "Unsupported compiler")
	endif()
endfunction()