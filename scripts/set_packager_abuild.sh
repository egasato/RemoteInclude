#!/usr/bin/env bash

# Sets the packager used inside abuild.conf
function set_packager_abuild() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v author_contact="$1" -f "$__dirname/set_packager_abuild.gawk" "$__dirname/../.abuild/abuild.conf" > "$__dirname/../.abuild/abuild.conf.tmp"
    mv "$__dirname/../.abuild/abuild.conf.tmp" "$__dirname/../.abuild/abuild.conf"
}
