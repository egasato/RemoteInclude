#######################################################################
# Copyright (c) 2018 Esaú García Sánchez-Torija                       #
#                                                                     #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#######################################################################

# Include the module that allows us to parse arguments
include(CMakeParseArguments)

# If the name is already registered stop everything
if (COMMAND RemoteInclude OR COMMAND _RemoteInclude)
    message(FATAL_ERROR "Macro name collision. The name \"RemoteInclude\" or \"_RemoteInclude\" already exists.")
    return()
endif (COMMAND RemoteInclude OR COMMAND _RemoteInclude)

# Create the function that downloads the file
function(_RemoteInclude include_path inclusion_name)

    # Sanitize the known parameters
    if (inclusion_name STREQUAL "")
        message(FATAL_ERROR "The parameter \"inclusion_name\" cannot be empty.")
        return()
    endif ()

    # Parse the rest of the arguments
    cmake_parse_arguments(
            REMOTE_INCLUDE                                                                # Prefix for the output variables
            "SHOW_PROGRESS;OVERWRITE"                                                     # Boolean arguments
            "URL;INACTIVITY_TIMEOUT;TIMEOUT;CACHE;EXPECTED_HASH;EXPECTED_MD5;DESTINATION" # Mono-valued arguments
            ""                                                                            # Multi-valued arguments
            ${ARGN}                                                                       # The arguments to parse
    )

    # Check the parsed parameters
    if (NOT DEFINED REMOTE_INCLUDE_URL OR REMOTE_INCLUDE_URL STREQUAL "")
        message(FATAL_ERROR "The parameter \"URL\" cannot be empty.")
        return()
    elseif (NOT DEFINED REMOTE_INCLUDE_DESTINATION OR REMOTE_INCLUDE_DESTINATION STREQUAL "")
        message(FATAL_ERROR "The parameter \"DESTINATION\" cannot be empty.")
        return()
    elseif (DEFINED REMOTE_INCLUDE_INACTIVITY_TIMEOUT AND REMOTE_INCLUDE_INACTIVITY_TIMEOUT LESS 0 AND NOT REMOTE_INCLUDE_INACTIVITY_TIMEOUT GREATER_EQUAL 0)
        message(FATAL_ERROR "The parameter \"INACTIVITY_TIMEOUT\" cannot be less than 0.")
        return()
    elseif (DEFINED REMOTE_INCLUDE_TIMEOUT AND REMOTE_INCLUDE_TIMEOUT LESS_EQUAL 0 AND NOT REMOTE_INCLUDE_TIMEOUT GREATER 0)
        message(FATAL_ERROR "The parameter \"TIMEOUT\" cannot be less than or equal to 0.")
        return()
    endif (NOT DEFINED REMOTE_INCLUDE_URL OR REMOTE_INCLUDE_URL STREQUAL "")

    # Transform the destination to be an absolute path
    set(REMOTE_INCLUDE_DESTINATION_COPY "${REMOTE_INCLUDE_DESTINATION}")
    if (NOT REMOTE_INCLUDE_DESTINATION MATCHES "^([A-Z]+:)?/")
        set(REMOTE_INCLUDE_DESTINATION "${CMAKE_CURRENT_BINARY_DIR}/downloads/${REMOTE_INCLUDE_DESTINATION}")
        get_filename_component(REMOTE_INCLUDE_DESTINATION "${REMOTE_INCLUDE_DESTINATION}" ABSOLUTE)
    endif (NOT REMOTE_INCLUDE_DESTINATION MATCHES "^([A-Z]+:)?/")

    # Set the default parameters
    if (NOT DEFINED REMOTE_INCLUDE_INACTIVITY_TIMEOUT)
        set(REMOTE_INCLUDE_INACTIVITY_TIMEOUT 0)
    endif (NOT DEFINED REMOTE_INCLUDE_INACTIVITY_TIMEOUT)
    if (NOT DEFINED REMOTE_INCLUDE_TIMEOUT)
        set(REMOTE_INCLUDE_TIMEOUT 2)
    endif (NOT DEFINED REMOTE_INCLUDE_TIMEOUT)

    # Build the parameters list
    list(APPEND file_args DOWNLOAD "${REMOTE_INCLUDE_URL}")
    list(APPEND file_args "${REMOTE_INCLUDE_DESTINATION}")
    list(APPEND file_args INACTIVITY_TIMEOUT ${REMOTE_INCLUDE_INACTIVITY_TIMEOUT})
    list(APPEND file_args TIMEOUT ${REMOTE_INCLUDE_TIMEOUT})
    if (REMOTE_INCLUDE_SHOW_PROGRESS)
        list(APPEND file_args SHOW_PROGRESS)
    endif (REMOTE_INCLUDE_SHOW_PROGRESS)
    if (DEFINED REMOTE_INCLUDE_EXPECTED_HASH)
        list(APPEND file_args EXPECTED_HASH "${REMOTE_INCLUDE_EXPECTED_HASH}")
    endif (DEFINED REMOTE_INCLUDE_EXPECTED_HASH)
    if (DEFINED REMOTE_INCLUDE_EXPECTED_MD5)
        list(APPEND file_args EXPECTED_MD5 "${REMOTE_INCLUDE_EXPECTED_MD5}")
    endif (DEFINED REMOTE_INCLUDE_EXPECTED_MD5)
    list(APPEND file_args TLS_VERIFY ON)

    # If the directory does not exist create it
    get_filename_component(REMOTE_INCLUDE_DESTINATION_DIR "${REMOTE_INCLUDE_DESTINATION}" DIRECTORY)
    if (EXISTS "${REMOTE_INCLUDE_DESTINATION_DIR}")
        if (NOT IS_DIRECTORY "${REMOTE_INCLUDE_DESTINATION_DIR}")
            message(FATAL_ERROR "The path \"${REMOTE_INCLUDE_DESTINATION_DIR}\" exists but is not a directory, thus the file cannot be saved inside it.")
            return()
        endif (NOT IS_DIRECTORY "${REMOTE_INCLUDE_DESTINATION_DIR}")
    else (EXISTS "${REMOTE_INCLUDE_DESTINATION_DIR}")
        message(STATUS "[RemoteInclude(${inclusion_name})]: Creating directory ${REMOTE_INCLUDE_DESTINATION_DIR}")
        file(MAKE_DIRECTORY "${REMOTE_INCLUDE_DESTINATION_DIR}")
    endif (EXISTS "${REMOTE_INCLUDE_DESTINATION_DIR}")

    # If the destination already exists and is not a file, we won't be able to write into it
    if (EXISTS "${REMOTE_INCLUDE_DESTINATION}")
        if (IS_DIRECTORY "${REMOTE_INCLUDE_DESTINATION}")
            message(FATAL_ERROR "The path \"${REMOTE_INCLUDE_DESTINATION}\" already exists and is a directory.")
            return()
        endif (IS_DIRECTORY "${REMOTE_INCLUDE_DESTINATION}")

        # Make sure that the user wants to overwrite the file
        # because CMake auto-reload feature can destroy files accidentally
        if (NOT REMOTE_INCLUDE_OVERWRITE)
            message(STATUS "[RemoteInclude(${inclusion_name})]: To prevent accidental overwrites you must explicitly indicate that you want to do so. Skipping download.")
            return()
        endif (NOT REMOTE_INCLUDE_OVERWRITE)

        # If the file is newer than the cache, then skip the download
        if (DEFINED REMOTE_INCLUDE_CACHE AND NOT REMOTE_INCLUDE_CACHE EQUALS 0)
            if (DEFINED REMOTE_INCLUDE_UNIX_TIME_${inclusion_name})
                string(TIMESTAMP unix_time "%s" UTC)
                math(EXPR ago "${unix_time} - ${REMOTE_INCLUDE_UNIX_TIME_${inclusion_name}}")
                if (REMOTE_INCLUDE_CACHE LESS 0 OR NOT ago GREATER REMOTE_INCLUDE_CACHE)
                    message(STATUS "[RemoteInclude(${inclusion_name})]: Skipping download because of the cache configuration")
                    return()
                endif (NOT ago GREATER REMOTE_INCLUDE_CACHE)
            endif (DEFINED REMOTE_INCLUDE_UNIX_TIME_${inclusion_name})
        endif (DEFINED REMOTE_INCLUDE_CACHE)
    endif (EXISTS "${REMOTE_INCLUDE_DESTINATION}")

    # Download the file
    message(STATUS "[RemoteInclude(${inclusion_name})]: Downloading ${REMOTE_INCLUDE_URL} into ${REMOTE_INCLUDE_DESTINATION}")
    string(TIMESTAMP unix_time "%s" UTC)
    set(REMOTE_INCLUDE_UNIX_TIME_${inclusion_name} ${unix_time} INTERNAL)
    file(${file_args})

    # Set the destination path in the parent scope
    set("${include_path}" "${REMOTE_INCLUDE_DESTINATION}" PARENT_SCOPE)

endfunction(_RemoteInclude)

# Create the macro that downloads the file and then includes it
macro(RemoteInclude inclusion_name)

    # Download the file
    _RemoteInclude("_REMOTE_INCLUDE_${inclusion_name}_DESTINATION" ${ARGV})

    # Include it
    message(STATUS "[RemoteInclude(${inclusion_name})]: Including file ${_REMOTE_INCLUDE_${inclusion_name}_DESTINATION}")
    include("${_REMOTE_INCLUDE_${inclusion_name}_DESTINATION}")

    # Unset all the variables
    unset("_REMOTE_INCLUDE_${inclusion_name}_DESTINATION")

endmacro(RemoteInclude)
