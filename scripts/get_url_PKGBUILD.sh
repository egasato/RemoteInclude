#!/usr/bin/env bash

# Returns the project url used inside PKGBUILD
function get_url_PKGBUILD() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -f "$__dirname/get_url.gawk" "$__dirname/../PKGBUILD" | sed "s/\${pkgname}/$1/"
}
