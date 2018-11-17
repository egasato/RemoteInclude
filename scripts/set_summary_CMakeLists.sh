#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")

# Sets the project summary used inside CMakeLists.txt
function set_summary_CMakeLists() {
    gawk -v project_description="$1" -f "$__dirname/set_summary_CMakeLists.gawk" "$__dirname/../CMakeLists.txt" > "$__dirname/../CMakeLists.txt.tmp"
    mv "$__dirname/../CMakeLists.txt.tmp" "$__dirname/../CMakeLists.txt"
}
