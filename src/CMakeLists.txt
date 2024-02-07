
if (CMAKE_CROSSCOMPILING)
	add_library(cortex_m STATIC
		reset_handler.s
		system.cpp
	)

	# Remove `pedantic` as we call `main`
	set_source_files_properties(system.cpp
		PROPERTIES
			COMPILE_FLAGS "-Wno-pedantic -Wno-useless-cast -Wno-sign-conversion -Wno-old-style-cast -fno-tree-loop-distribute-patterns")

	target_link_libraries(cortex_m
		PRIVATE
			bob_interface
			stm32_cmsis
	)
	target_include_directories(cortex_m
		PUBLIC
			${PROJECT_BINARY_DIR}
			${PROJECT_SOURCE_DIR}/include
	)

	add_subdirectory(stm32f7)

	set_target_properties(cortex_m
		PROPERTIES
			SOVERSION ${PROJECT_VERSION_MAJOR}
			VERSION ${PROJECT_VERSION}
	)

	#
	# export
	#

	include(GenerateExportHeader)
	generate_export_header(cortex_m)

	#
	# install
	#

	# add_library(Libstartup::cortex_m ALIAS cortex_m)

	include(CMakePackageConfigHelpers)
	include(GNUInstallDirs)

	set(Libstartup_INSTALL_CMAKEDIR "${CMAKE_INSTALL_LIBDIR}/cmake/libstartup" CACHE STRING "Path to install cmake files")

	set(INCLUDE_INSTALL_DIR   "${CMAKE_INSTALL_INCLUDEDIR}/libstartup" CACHE PATH "Location of header files")
	set(SYSCONFIG_INSTALL_DIR "${CMAKE_INSTALL_SYSCONFDIR}/libstartup" CACHE PATH "Location of configuration files")

	configure_package_config_file(
		LibstartupConfig.cmake.in
		${CMAKE_CURRENT_BINARY_DIR}/LibstartupConfig.cmake
		INSTALL_DESTINATION
			${Libstartup_INSTALL_CMAKEDIR}
		PATH_VARS
			INCLUDE_INSTALL_DIR
			SYSCONFIG_INSTALL_DIR
	)

	write_basic_package_version_file(
		LibstartupConfigVersion.cmake
		VERSION
			${PROJECT_VERSION}
		COMPATIBILITY
			SameMajorVersion
	)

	install(FILES
		${CMAKE_CURRENT_BINARY_DIR}/LibstartupConfig.cmake
		${CMAKE_CURRENT_BINARY_DIR}/LibstartupConfigVersion.cmake
		DESTINATION
			${Libstartup_INSTALL_CMAKEDIR}
	)

	install(TARGETS cortex_m
		EXPORT
			Libstartup_Targets
		INCLUDES DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
		RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
			COMPONENT Libstartup_RunTime
		LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
			COMPONENT Libstartup_RunTime
			NAMELINK_COMPONENT Libstartup_Development
		ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
			COMPONENT Libstartup_Development
	)

	# install(EXPORT Libstartup_Targets
		# DESTINATION ${Libstartup_INSTALL_CMAKEDIR}
		# NAMESPACE Libstartup::
		# FILE Libstartup-Targets.cmake
		# COMPONENT Libstartup_Development
	# )

endif()
