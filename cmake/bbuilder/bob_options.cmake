
option(BOB_USE_DEBUG_SYMBOLS	"Embed debug symbols" ON)
option(BOB_USE_EXCEPTIONS		"Allow exceptions" OFF)
option(BOB_USE_RTTI				"Generate run-time type identification (RTTI)" OFF)

function(bob_configure_options target)
	if((CMAKE_CXX_COMPILER_ID STREQUAL "GNU") OR (CMAKE_CXX_COMPILER_ID STREQUAL "Clang"))
		target_compile_options(${target}
			INTERFACE
				$<$<BOOL:${BOB_USE_DEBUG_SYMBOLS}>:-gdwarf-5>
				$<$<BOOL:${BOB_USE_EXCEPTIONS}>:-fexceptions>
				$<$<NOT:$<BOOL:${BOB_USE_EXCEPTIONS}>>:-fno-exceptions>
				$<$<NOT:$<BOOL:${BOB_USE_EXCEPTIONS}>>:-fno-unwind-tables>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<BOOL:${BOB_USE_RTTI}>>:-frtti>
				$<$<AND:$<COMPILE_LANGUAGE:CXX>,$<NOT:$<BOOL:${BOB_USE_RTTI}>>>:-fno-rtti>
		)
	else()
		bob_error("unsupported compiler")
	endif()
endfunction()
