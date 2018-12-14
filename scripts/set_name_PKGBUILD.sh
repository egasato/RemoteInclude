#!/usr/bin/env bash

# Sets the project name used inside PKGBUILD
function set_name_PKGBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v project_name="$1" -v project_name_lower="$(echo "$1" | tr 'A-Z' 'a-z' | tr -s ' ' | tr ' ' '-')" -f "$__dirname/set_name.gawk" "$__dirname/../PKGBUILD" > "$__dirname/../PKGBUILD.tmp"
    mv "$__dirname/../PKGBUILD.tmp" "$__dirname/../PKGBUILD"
}
