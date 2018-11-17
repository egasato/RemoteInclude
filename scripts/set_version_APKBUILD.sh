#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")

# Sets the version number used inside APKBUILD
function set_version_APKBUILD() {
    gawk -v project_version="$1" -f "$__dirname/set_version_APKBUILD.gawk" APKBUILD > APKBUILD.tmp
    mv APKBUILD.tmp APKBUILD
}
