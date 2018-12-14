#!/usr/bin/env bash

# Sets the project source url used inside APKBUILD
function set_source_APKBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v project_source="$1" -v project_name="$2" -v project_version="$3" -f "$__dirname/set_source_APKBUILD.gawk" "$__dirname/../APKBUILD" > "$__dirname/../APKBUILD.tmp"
    mv "$__dirname/../APKBUILD.tmp" "$__dirname/../APKBUILD"
}
