#!/usr/bin/env bash

# Sets the project url used inside PKGBUILD
function set_url_PKGBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v project_url="$1" -v project_name="$2" -f "$__dirname/set_url.gawk" "$__dirname/../PKGBUILD" > "$__dirname/../PKGBUILD.tmp"
    mv "$__dirname/../PKGBUILD.tmp" "$__dirname/../PKGBUILD"
}
