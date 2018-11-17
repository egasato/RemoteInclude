#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")

# Returns the project name used inside APKBUILD
function get_name_APKBUILD() {
    gawk -f "$__dirname/get_name_APKBUILD.gawk" APKBUILD
}
