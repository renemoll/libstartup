
option(BOB_USE_FPU "Enable Floating Point Unit (FPU) hardware ABI" ON)
option(BOB_USE_RTTI "Generate run-time type identification (RTTI)" OFF)
option(BOB_USE_EXCEPTIONS "Allow exceptions" OFF)
option(BOB_COMPILER_WARN_EVERYTHING "Enable -Weverything (Clang only)" OFF)

function(bob_configure_options target)
	if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
		target_compile_options(${target}
			INTERFACE
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<BOOL:${BOB_USE_RTTI}>>:-frtti>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<BOOL:${BOB_USE_RTTI}>>>:-fno-rtti>
		)

		target_compile_options(${target}
			INTERFACE
				$<$<BOOL:${BOB_USE_EXCEPTIONS}>:-fexceptions>
				$<$<NOT:$<BOOL:${BOB_USE_EXCEPTIONS}>>:-fno-exceptions>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<BOOL:${BOB_USE_EXCEPTIONS}>>>:-fno-use-cxa-atexit>
		)

		target_compile_options(${target}
			INTERFACE
				$<$<AND:$<BOOL:${BOB_COMPILER_WARN_EVERYTHING}>,$<CXX_COMPILER_ID:Clang>>:-Weverything>
		)
	else()
		message(FATAL_ERROR "Unsupported compiler")
	endif()
endfunction()