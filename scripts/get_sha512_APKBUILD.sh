#!/usr/bin/env bash

# Returns the SHA512 hash used inside APKBUILD
function get_sha512_APKBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -f "$__dirname/get_sha512_APKBUILD.gawk" "$__dirname/../APKBUILD"
}
