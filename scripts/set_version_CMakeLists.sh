#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")

# Sets the version number used inside CMakeLists.txt
function set_version_CMakeLists() {
    gawk -v project_version="$1" -f "$__dirname/set_version_CMakeLists.gawk" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}
