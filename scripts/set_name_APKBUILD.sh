#!/usr/bin/env bash

# Sets the project name used inside APKBUILD
function set_name_APKBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v project_name="$1" -f "$__dirname/set_name_APKBUILD.gawk" "$__dirname/../APKBUILD" > "$__dirname/../APKBUILD.tmp"
    mv "$__dirname/../APKBUILD.tmp" "$__dirname/../APKBUILD"
}
