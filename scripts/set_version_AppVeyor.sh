#!/usr/bin/env bash

# Sets the version number used inside .appveyor.yml
function set_version_AppVeyor() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk -v project_version="$1" -f "$__dirname/set_version_AppVeyor.gawk" "$__dirname/../.appveyor.yml" > "$__dirname/../.appveyor.yml.tmp"
    mv "$__dirname/../.appveyor.yml.tmp" "$__dirname/../.appveyor.yml"
}
