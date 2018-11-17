#!/usr/bin/env bash

# Returns the project description used inside CMakeLists.txt
function get_description_CMakeLists() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -f "$__dirname/get_description_CMakeLists.gawk" "$__dirname/../CMakeLists.txt"
}
