#!/usr/bin/env bash

# Sets the arguments used inside Dockerfile.apk
function set_args_apk() {
    local __filename
    if [[ "${BASH_SOURCE[0]}" == "" ]]; then
        __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
    else
        __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
    fi
    local __dirname=$(dirname "$__filename")
    gawk                             \
        -v author_user="$1"          \
        -v author_name="$2"          \
        -v author_name_ascii="$3"    \
        -v author_email="$4"         \
        -v author_contact="$5"       \
        -v author_contact_ascii="$6" \
        \
        -v project_name="$7"            \
        -v project_description="$8"     \
        -v project_version="$9"         \
        -v project_sha512="${10}"       \
        -v project_vendor="${11}"       \
        -v project_vendor_ascii="${12}" \
        -v project_homepage="${13}"     \
        -v project_url="${14}"          \
        -v project_vcs="${15}"          \
        -v project_source="${16}"       \
        \
        -v label_build_date="${17}"  \
        -v label_name="${18}"        \
        -v label_description="${19}" \
        -v label_usage="${20}"       \
        -v label_url="${21}"         \
        -v label_vcs_url="${22}"     \
        -v label_vcs_ref="${23}"     \
        -v label_vendor="${24}"      \
        -v label_version="${25}"     \
        \
        -f "$__dirname/set_args_apk.gawk" "$__dirname/../Dockerfile.apk" > "$__dirname/../Dockerfile.apk.tmp"
    mv "$__dirname/../Dockerfile.apk.tmp" "$__dirname/../Dockerfile.apk"
}
