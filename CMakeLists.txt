#######################################################################
# Copyright (c) 2018 Esaú García Sánchez-Torija                       #
#                                                                     #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#######################################################################

# Specify the minimum required version for CMake
cmake_minimum_required(VERSION 3.0.2 FATAL_ERROR)

# Configure the project
# @formatter:off
project(
        RemoteInclude
        VERSION       1.0.0.0
        DESCRIPTION  "Adds support for the inclusion of remote CMake scripts"
        HOMEPAGE_URL  https://github.com/egasato/RemoteInclude
        LANGUAGES     NONE
)
# @formatter:on

#######################################################################
######################## PACKAGE CONFIGURATION ########################
#######################################################################

# Adds support for the GNU installation guidelines
include(GNUInstallDirs)

# Adds support for automatic "XXXConfigVersion..cmake" creation
include(CMakePackageConfigHelpers)

# Write the ConfigVersion file
# @formatter:off
write_basic_package_version_file(
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
        VERSION       ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
)
# @formatter:on

# Create the configuration file to use the project without installing
# @formatter:off
set(RemoteInclude_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/.cmake")
configure_package_config_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}Config.cmake.in
        ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        INSTALL_DESTINATION ${CMAKE_BINARY_DIR}
        PATH_VARS           RemoteInclude_CMAKE_DIR
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
)
# @formatter:on

## Created the configuration file to install

if (WIN32)
    set(RemoteInclude_CMAKE_DIR "cmake")
    set(install_destination /)
else ()
    set(RemoteInclude_CMAKE_DIR "${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}/cmake")
    set(install_destination ${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME})
endif ()

# @formatter:off
configure_package_config_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}Config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigExport.cmake
        INSTALL_DESTINATION ${install_destination}
        PATH_VARS           RemoteInclude_CMAKE_DIR
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
)
# @formatter:on

# If this project is being included by another project
# copy the CMake configuration files to the global build dir
if ("${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    configure_file(${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake COPYONLY)
    configure_file(${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake COPYONLY)
endif ()

#######################################################################
############################ INSTALL RULES ############################
#######################################################################

# Install the necessary files
if (WIN32)
    # @formatter:off
    install(
            FILES       ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}.cmake
            DESTINATION cmake
    )
    install(
            FILES       ${CMAKE_BINARY_DIR}${CMAKE_FILES_DIRECTORY}/${PROJECT_NAME}ConfigVersion.cmake
            DESTINATION /
    )
    install(
            FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigExport.cmake
            RENAME      ${PROJECT_NAME}Config.cmake
            DESTINATION /
    )
    # @formatter:on
else ()
    # @formatter:off
    install(
            FILES       ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}.cmake
            DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}
    )
    install(
            FILES       ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
            DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PACKAGE_NAME}
    )
    install(
            FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigExport.cmake
            DESTINATION ${CMAKE_INSTALL_DATADIR}/cmake/${PROJECT_NAME}
            RENAME      ${PACKAGE_NAME}Config.cmake
    )
    # @formatter:on
endif ()

# Export the package to the user's CMake registry
#export(PACKAGE RemoteInclude)
