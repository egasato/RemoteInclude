#!/usr/bin/env bash

# Returns the SHA256 hash used inside PKGBUILD
function get_sha256_PKGBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -f "$__dirname/get_sha256_PKGBUILD.gawk" "$__dirname/../PKGBUILD"
}