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
project(RemoteInclude
        VERSION   1.0.0.0
        LANGUAGES NONE
)
set(PROJECT_DESCRIPTION "Adds support for the inclusion of remote CMake scripts")
set(PROJECT_HOMEPAGE_URL https://github.com/egasato/RemoteInclude)
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
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
        VERSION       ${PROJECT_VERSION}
        COMPATIBILITY AnyNewerVersion
)
# @formatter:on

## Create the configuration file to install

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

# Create the configuration file to use the project without installing
# @formatter:off
set(RemoteInclude_CMAKE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/.cmake")
configure_package_config_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}Config.cmake.in
        ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}Config.cmake
        INSTALL_DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
        PATH_VARS           RemoteInclude_CMAKE_DIR
        NO_CHECK_REQUIRED_COMPONENTS_MACRO
)
# @formatter:on

# If this project is being included by another project
# copy the CMake configuration files to the global build dir
if (NOT "${CMAKE_CURRENT_BINARY_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    configure_file(${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake ${CMAKE_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake COPYONLY)
    configure_package_config_file(
            ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}Config.cmake.in
            ${CMAKE_BINARY_DIR}/${PROJECT_NAME}Config.cmake
            INSTALL_DESTINATION ${CMAKE_BINARY_DIR}
            PATH_VARS           RemoteInclude_CMAKE_DIR
            NO_CHECK_REQUIRED_COMPONENTS_MACRO
    )
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
            FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
            DESTINATION /
    )
    install(
            FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigExport.cmake
            DESTINATION /
            RENAME      ${PROJECT_NAME}Config.cmake
    )
    # @formatter:on
else ()
    # @formatter:off
    install(
            FILES       ${CMAKE_CURRENT_SOURCE_DIR}/.cmake/${PROJECT_NAME}.cmake
            DESTINATION ${CMAKE_INSTALL_DATADIR}/${PROJECT_NAME}
    )
    install(
            FILES       ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}ConfigVersion.cmake
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
export(PACKAGE RemoteInclude)

#######################################################################
########################### INSTALLER RULES ###########################
#######################################################################

# @formatter:off
set(CPACK_GENERATOR                   "TBZ2;TGZ;TXZ;TZ;ZIP;STGZ")
set(CPACK_PACKAGE_NAME                "${PROJECT_NAME}")
set(CPACK_PACKAGE_VENDOR              "Esau Garcia Sanchez-Torija")
set(CPACK_PACKAGE_DESCRIPTION_SUMMARY "${PROJECT_NAME} - Simple CMake script to download and auto-include remote CMake scripts")
set(CPACK_PACKAGE_VERSION              ${PROJECT_VERSION})
set(CPACK_PACKAGE_VERSION_MAJOR        ${PROJECT_VERSION_MAJOR})
set(CPACK_PACKAGE_VERSION_MINOR        ${PROJECT_VERSION_MINOR})
set(CPACK_PACKAGE_VERSION_PATCH        ${PROJECT_VERSION_PATCH})
set(CPACK_PACKAGE_VERSION_TWEAK        ${PROJECT_VERSION_TWEAK})
set(CPACK_PACKAGE_INSTALL_DIRECTORY    ${PROJECT_NAME})
set(CPACK_PACKAGE_ICON                 ${CMAKE_CURRENT_SOURCE_DIR}/media/Logo.png)

set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")

set(CPACK_SOURCE_GENERATOR         "TBZ2;TGZ;TXZ;TZ;ZIP;STGZ")
set(CPACK_SOURCE_PACKAGE_FILE_NAME "${PROJECT_NAME}")
list(APPEND CPACK_SOURCE_IGNORE_FILES build test media .git* .idea README.md)
# @formatter:on

# Enable extra generators for Windows
if (WIN32)

    # Enable the NSIS installer and configure it
    # @formatter:off
    list(APPEND CPACK_SOURCE_GENERATOR  7Z)
    list(APPEND CPACK_GENERATOR         7Z NSIS NSIS64)
    set(CPACK_NSIS_MODIFY_PATH          OFF)
    set(CPACK_NSIS_DISPLAY_NAME        "${PROJECT_NAME} ${PROJECT_VERSION}")
    set(CPACK_NSIS_HELP_LINK           "${PROJECT_HOMEPAGE_URL}")
    set(CPACK_NSIS_URL_INFO_ABOUT      "${PROJECT_HOMEPAGE_URL}")
    set(CPACK_NSIS_MUI_ICON            "${CMAKE_CURRENT_SOURCE_DIR}/media/Logo.ico")
    set(CPACK_NSIS_MUI_UNIICON         "${CMAKE_CURRENT_SOURCE_DIR}/media/Logo.ico")
    set(CPACK_NSIS_INSTALLED_ICON_NAME "${CMAKE_CURRENT_SOURCE_DIR}/media/Logo.ico")
    # @formatter:on

    # Enable the WiX installer and configure it
    list(APPEND CPACK_GENERATOR WIX)
    set(CPACK_WIX_UPGRADE_GUID "A5997055-3D22-4447-A476-71AC4D7911FC")
    set(CPACK_WIX_PRODUCT_ICON "${CMAKE_CURRENT_SOURCE_DIR}/media/Logo.ico")

    # WiX requires the license to be RTF or TXT, so create a duplicate with another extension
    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/LICENSE ${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt COPYONLY)
    set(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_BINARY_DIR}/LICENSE.txt")

    # @formatter:off
    # Fix paths to be Windows-like (with backslash)
    string(REPLACE "/" "\\\\" CPACK_PACKAGE_ICON             "${CPACK_PACKAGE_ICON}")
    string(REPLACE "/" "\\\\" CPACK_NSIS_MUI_ICON            "${CPACK_NSIS_MUI_ICON}")
    string(REPLACE "/" "\\\\" CPACK_NSIS_MUI_UNIICON         "${CPACK_NSIS_MUI_UNIICON}")
    string(REPLACE "/" "\\\\" CPACK_NSIS_INSTALLED_ICON_NAME "${CPACK_NSIS_MUI_ICON}")
    string(REPLACE "/" "\\\\" CPACK_WIX_PRODUCT_ICON         "${CPACK_WIX_PRODUCT_ICON}")
    string(REPLACE "/" "\\\\" CPACK_RESOURCE_FILE_LICENSE    "${CPACK_RESOURCE_FILE_LICENSE}")
    # @formatter:on

endif ()

# Include the CPack dependency
include(CPack)
