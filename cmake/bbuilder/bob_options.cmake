
option(USE_HW_FPU "Enable floating point hardware ABI" ON)
option(USE_RTTI "Generate run-time type identification (RTTI)" OFF)
option(USE_EXCEPTIONS "Allow exceptions" OFF)
option(COMPILER_WARN_EVERYTHING "Enable -Weverything (Clang only)" OFF)

function(bob_configure_options target)
	if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
		target_compile_options(${target}
			INTERFACE
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<BOOL:${USE_RTTI}>>:-frtti>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<BOOL:${USE_RTTI}>>>:-fno-rtti>
		)

		target_compile_options(${target}
			INTERFACE
				$<$<BOOL:${USE_EXCEPTIONS}>:-fexceptions>
				$<$<NOT:$<BOOL:${USE_EXCEPTIONS}>>:-fno-exceptions>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<BOOL:${USE_EXCEPTIONS}>>>:-fno-use-cxa-atexit>
		)

		target_compile_options(${target}
			INTERFACE
				$<$<AND:$<BOOL:${COMPILER_WARN_EVERYTHING}>,$<CXX_COMPILER_ID:Clang>>:-Weverything>
		)
	else()
		message(FATAL_ERROR "Unsupported compiler")
	endif()
endfunction()