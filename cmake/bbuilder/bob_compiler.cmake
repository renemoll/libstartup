#
# Compiler configuration
#

if((CMAKE_C_COMPILER_ID MATCHES "Clang") OR (CMAKE_CXX_COMPILER_ID MATCHES "Clang"))
	set(BOB_COMPILER_CLANG On)

	option(BOB_CLANG_WARN_EVERYTHING "Enable `-Weverything` for Clang" OFF)
elseif((CMAKE_CXX_COMPILER_ID MATCHES "GNU") OR (CMAKE_C_COMPILER_ID MATCHES "GNU"))
	set(BOB_COMPILER_GCC On)
elseif(MSVC)
	set(BOB_COMPILER_MSVC On)
else()
	bob_error("unsupported compiler.")
endif()

function(bob_configure_compiler_warnings TARGET)
	set(BOB_COMPILER_WARNINGS_GNU_CLANG
		# General
		-Wall												# Enable warnings for common coding mistakes or potential errors.
		-Wextra												# Extensions for -Wall.
		-Werror												# Treat warnings as errors to fail the build in case of warnings.
		-Wpedantic											# Warn for now standard C++.
		# (Type) conversion
		-Wconversion										# Warn about implicit type conversions which (may) change the value.
		-Wsign-conversion									# Warn about implicit sign conversions.
		-Wdouble-promotion									# Warn about floats being implictly converted to doubles.
		-Wfloat-equal										# Warn about floatint point values used in equality tests.
		-Wpointer-arith										# Warn when sizeof(void) is used (directly or indirectly).
		$<$<COMPILE_LANGUAGE:CXX>:-Wold-style-cast>			# Warn about C-style casts.
		-Wcast-qual											# Warn when casting removes a type qualifier from a pointer.
		-Wcast-align										# Warn when casting a pointers changes the alignment of the pointee.
		$<$<COMPILE_LANGUAGE:C>:-Wbad-function-cast>		# Warn about casts to function pointers.
		# Classes
		$<$<COMPILE_LANGUAGE:CXX>:-Wnon-virtual-dtor>		# Warn about base classes without virtual destructors.
		$<$<COMPILE_LANGUAGE:CXX>:-Wctor-dtor-privacy>		# Warn about classes which seemingly cannot be used.
		$<$<COMPILE_LANGUAGE:CXX>:-Wsuggest-override>		# Warn when a method overwriting a virtual method is not marked with override.
		$<$<COMPILE_LANGUAGE:CXX>:-Woverloaded-virtual>		# Warn when a derived function hides a virtual function of the base class.
		# Misc
		-Wshadow											# Warn about duplicated variable names.
		-Wswitch-enum										# Warn about switch statements not using all possible enum values.
		-Wimplicit-fallthrough								# Warn about implicit, un-annotated, fallthroughs.
		-Wnull-dereference									# Warn about possible null pointer dereference code paths.
		-Wundef												# Warn when undefined macros are used (implicit conversion to 0.)
		$<$<COMPILE_LANGUAGE:C>:-Wstrict-prototypes>		# Warn when a function declaration misses argument types.
		-Wunused											# Warn about any unused parameter/function/variable/etc...
		-Wmisleading-indentation							# Warn about indentation giving the impression of scope.
		-Winline											# Warn when desired inlining is not possible.
		-Wzero-as-null-pointer-constant						# Warn about the use of 0 as nullptr.
		# Strings related
		-Wvla												# Warn about variable-length arrays being used.
		-Wwrite-strings										# Warn when attempting to write to a string constant.
		-Wformat=2											# Verify printf/scanf/.. arguments and format strings match.
	)

	set(BOB_COMPILER_WARNINGS_GNU
		-fdiagnostics-color=always							# Generate colourized diagnostic warnings.
		# (Type) conversion
		-Warith-conversion									# Warn about implicit type conversions during arithmitic operations.
		$<$<COMPILE_LANGUAGE:CXX>:-Wuseless-cast>			# Warn about casting to the same type.
		-Wcast-align=strict
		# Misc
		-Wduplicated-branches								# Warn about identifcal branches in if-else expressions.
		-Wduplicated-cond									# Warn about duplicated conditions in if-else expressions.
		-Wredundant-decls									# Warn about multiple declarations within the same scope.
		-Wlogical-op										# Warn about potential errors with logical operations.
		-Wtrampolines										# Warn about code to jump to a function, requiring an executable stack.
		-Warray-bounds=2									# Warns about invalid array indices.
		-Wstrict-null-sentinel								# Warn about the use of an uncasted NULL as sentinel.
		# Strings related
		-Wformat-truncation=2								# Warn when the output of sprintf/... might be truncated.
	)


	set(BOB_COMPILER_WARNINGS_CLANG
		-fcolor-diagnostics										# Generate colourized diagnostic warnings.
		$<$<BOOL:${BOB_CLANG_WARN_EVERYTHING}>:-Weverything>	# Enable all diagnostic warnings.
		# Misc
		-Wshadow-all											# Additional shadowing checks.
	)

	set(BOB_COMPILER_WARNINGS_MSVC
		/permissive-										# Conform to the C++ standard.
		/W4													# Enable almost all warnings.
		/WX													# Treat warnings as errors.
		# MSVC syntax: w<level><warning code>
		/w14062												# 'identifier' in a switch of enum 'enumeration' is not handled.
		/w14242												# 'identfier': conversion from 'type1' to 'type1', possible loss of data.
		/w14254												# 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data.
		/w14263												# 'function': member function does not override any base class virtual member function
		/w14265												# 'classname': class has virtual functions, but destructor is not virtual instances of this class may not be destructed correctly
		/w14287												# 'operator': unsigned/negative constant mismatch
		/we4289												# nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside the for-loop scope
		/w14296												# 'operator': expression is always 'boolean_value'
		/w14311												# 'variable': pointer truncation from 'type1' to 'type2'
		/w14388												# 'token' : signed/unsigned mismatch
		/w14545												# expression before comma evaluates to a function which is missing an argument list
		/w14546												# function call before comma missing argument list
		/w14547												# 'operator': operator before comma has no effect; expected operator with side-effect
		/w14549												# 'operator': operator before comma has no effect; did you intend 'operator'?
		/w14555												# expression has no effect; expected expression with side-effect
		/w14619												# pragma warning: there is no warning number 'number'
		/w14640												# Enable warning on thread un-safe static member initialization
		/w14668												# 'symbol' is not defined as a preprocessor macro, replacing with '0' for 'directives'
		/w14800												# Implicit conversion from 'type' to bool. Possible information loss
		/w14826												# Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
		/w14928												# illegal copy-initialization; more than one user-defined conversion has been implicitly applied
		/w14946												# reinterpret_cast used between related classes: 'class1' and 'class2'
	)

	target_compile_options(${TARGET}
		INTERFACE
			$<$<CXX_COMPILER_ID:Clang>:${BOB_COMPILER_WARNINGS_GNU_CLANG}>
			$<$<CXX_COMPILER_ID:Clang>:${BOB_COMPILER_WARNINGS_CLANG}>
			$<$<CXX_COMPILER_ID:GNU>:${BOB_COMPILER_WARNINGS_GNU_CLANG}>
			$<$<CXX_COMPILER_ID:GNU>:${BOB_COMPILER_WARNINGS_GNU}>
			$<$<CXX_COMPILER_ID:MSVC>:${BOB_COMPILER_WARNINGS_MSVC}>
	)
endfunction()

function(bob_configure_compiler_codegen TARGET)
	set(BOB_COMPILER_BEHAVIOUR_GNU_CLANG
		-fno-common													# Warn when global variables are not unique (and unintentionaly merged.)
		-fstack-usage												# Generate stack depth information.
		-fvisibility=hidden											# Sets the default symbol visibility to hidden.
		-fvisibility-inlines-hidden									# Sets the default symbol visibility to hidden for inline functions.
		-fwrapv														# Assume signed arithmatic may wrap around.
		$<$<COMPILE_LANGUAGE:ASM>:-x assembler-with-cpp>			# Compile ASM as C++
		$<$<COMPILE_LANGUAGE:CXX>:-fdiagnostics-show-template-tree>	# Print template structures in a tree structure.
	)

	set(BOB_COMPILER_BEHAVIOUR_GNU
		$<$<NOT:$<CONFIG:Release>>:-fvar-tracking-assignments>	# Attempt to improve debugging by annotating variable assignment.
	)

	set(BOB_COMPILER_BEHAVIOUR_MSVC
		/diagnostics:caret									# Indicate where a warning was found in a line.
		/Gy													# Enable function level linking, allowing unreferenced data/functions to be exlcuded.
		/sdl												# Enable additional security checks.
		/Zc:__cplusplus										# Enable __cplusplus to report the supported standard.
		/Zc:externConstexpr									# Enable extern constexpr variables.
		/Zc:lambda											# Enable conforming lambda processor.
		/Zc:inline											# Remove unreferenced data and functions.
		/Zc:referenceBinding								# Enforce reference binding rules.
		/Zc:rvalueCast										# Enforce type conversion rules.
		/Zc:throwingNew										# Assume operator new throws.
	)

	target_compile_options(${TARGET}
		INTERFACE
			$<$<CXX_COMPILER_ID:Clang>:${BOB_COMPILER_BEHAVIOUR_GNU_CLANG}>
			$<$<CXX_COMPILER_ID:GNU>:${BOB_COMPILER_BEHAVIOUR_GNU_CLANG}>
			$<$<CXX_COMPILER_ID:GNU>:${BOB_COMPILER_BEHAVIOUR_GNU}>
			$<$<CXX_COMPILER_ID:MSVC>:${BOB_COMPILER_BEHAVIOUR_MSVC}>
	)
endfunction()
