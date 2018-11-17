#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")

# Sets the project url used inside APKBUILD
function set_url_APKBUILD() {
    gawk -v project_url="$1" -v project_name="$2" -f "$__dirname/set_url_APKBUILD.gawk" "$__dirname/../APKBUILD" > "$__dirname/../APKBUILD.tmp"
    mv "$__dirname/../APKBUILD.tmp" "$__dirname/../APKBUILD"
}
