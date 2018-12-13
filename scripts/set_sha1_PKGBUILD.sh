#!/usr/bin/env bash

# Sets the SHA1 hash used inside PKGBUILD
function set_sha1_PKGBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v project_sha1="$1" -v project_name="$2" -v project_version="$3" -f "$__dirname/set_sha1_PKGBUILD.gawk" "$__dirname/../PKGBUILD" > "$__dirname/../PKGBUILD.tmp"
    mv "$__dirname/../PKGBUILD.tmp" "$__dirname/../PKGBUILD"
}
