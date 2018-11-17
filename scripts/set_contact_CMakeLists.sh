#!/usr/bin/env bash

# Sets the author contact used inside CMakeLists.txt
function set_contact_CMakeLists() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v author_contact="$1" -f "$__dirname/set_contact_CMakeLists.gawk" "$__dirname/../CMakeLists.txt" > "$__dirname/../CMakeLists.txt.tmp"
    mv "$__dirname/../CMakeLists.txt.tmp" "$__dirname/../CMakeLists.txt"
}
