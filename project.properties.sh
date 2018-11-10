#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")
__name=$(basename "$__filename" ".sh")

# Read each line discarding comments and allowing multi-line variables with backslash
trim=""
concat=0
declare -a lines
while read -r line; do
    line=$(echo -n "$line" | sed -e 's/^[[:space:]]\+//' -e 's/[[:space:]]\+$//')
    if [[ ! "$line" =~ ^(#|!) ]] || [[ ${concat} -eq 1 ]]; then
        if [[ "${line:$((${#line}-1)):1}" == "\\" ]]; then
            line=$(echo -n "$line" | sed 's/[[:space:]]*\\/ /g')
            if [[ ${concat} -eq 1 ]]; then
                trim="$trim$line"
            else
                trim="$line"
            fi
            concat=1
        else
            if [[ ${concat} -eq 1 ]]; then
                trim="$trim$line"
            elif [[ "$line" == "" ]]; then
                continue
            else
                trim="$line"
            fi
            lines+=("$trim")
            concat=0
            trim=""
        fi
    fi
done < "$__dirname/$__name"

# Process the variables
declare -a _ULTRA_PRIVATE
for line in "${lines[@]}"; do
    no_var=$(echo -n "$line" | tr -d '[:alnum:]_[:space:]')
    delimiter="${no_var::1}"
    if [[ "$delimiter" != ":" ]] && [[ "$delimiter" != "=" ]] ; then
        echo "Bad line: $line"
        exit
    fi
    key=$(echo -n "$line"   | cut -d"$delimiter" -f 1  | sed -e 's/^[[:space:]]\+//' -e 's/[[:space:]]\+$//')
    value=$(echo -n "$line" | cut -d"$delimiter" -f 2- | sed -e 's/^[[:space:]]\+//' -e 's/[[:space:]]\+$//')
    if [[ "${key::1}" =~ ^[0-9]$ ]]; then
        echo "Bad variable name: $key"
        exit
    fi
    eval "_ULTRA_PRIVATE_$key='$value'"
    _ULTRA_PRIVATE+=("$key")
done

# Remove previous variables
unset __filename
unset __dirname
unset __name
unset trim
unset concat
unset lines
unset line
unset no_var
unset delimiter
unset key
unset value

# Remove the prefix from the variables
for var in "${_ULTRA_PRIVATE[@]}"; do
    eval "_${var}=\"\$_ULTRA_PRIVATE_${var}\""
    unset "_ULTRA_PRIVATE_$var"
done
unset _ULTRA_PRIVATE
unset var

## Set our variables
[[ "$_AUTHOR_CONTACT"       == "" ]] && _AUTHOR_CONTACT="$_AUTHOR_NAME <$_AUTHOR_EMAIL>"
[[ "$_AUTHOR_CONTACT_ASCII" == "" ]] && _AUTHOR_CONTACT_ASCII="$_AUTHOR_NAME_ASCII <$_AUTHOR_EMAIL>"
[[ "$_PROJECT_VENDOR"       == "" ]] && _PROJECT_VENDOR="$_AUTHOR_NAME (Open Source Developer)"
[[ "$_PROJECT_VENDOR_ASCII" == "" ]] && _PROJECT_VENDOR_ASCII="$_AUTHOR_NAME_ASCII (Open Source Developer)"
[[ "$_PROJECT_HOMEPAGE"     == "" ]] && _PROJECT_HOMEPAGE="https://$_AUTHOR_USER.github.io/$_PROJECT_NAME"
[[ "$_PROJECT_URL"          == "" ]] && _PROJECT_URL="https://github.com/$_AUTHOR_USER/$_PROJECT_NAME"
[[ "$_PROJECT_VCS"          == "" ]] && _PROJECT_VCS="$_PROJECT_URL.git"
[[ "$_PROJECT_SOURCE"       == "" ]] && _PROJECT_SOURCE="https://github.com/$_AUTHOR_USER/$_PROJECT_NAME/releases/download/$_PROJECT_NAME.tar.gz"
[[ "$_LABEL_BUILD_DATE"     == "" ]] && _LABEL_BUILD_DATE="$(date +%FT%T.%NZ)"
[[ "$_LABEL_NAME"           == "" ]] && _LABEL_NAME="$_PROJECT_NAME"
[[ "$_LABEL_DESCRIPTION"    == "" ]] && _LABEL_DESCRIPTION="$_PROJECT_DESCRIPTION"
[[ "$_LABEL_USAGE"          == "" ]] && _LABEL_USAGE="$_PROJECT_URL/blob/v$_PROJECT_VERSION/README.md"
[[ "$_LABEL_URL"            == "" ]] && _LABEL_URL="$_PROJECT_HOMEPAGE"
[[ "$_LABEL_VCS_URL"        == "" ]] && _LABEL_VCS_URL="$_PROJECT_VCS"
[[ "$_LABEL_VENDOR"         == "" ]] && _LABEL_VENDOR="$_PROJECT_VENDOR"
[[ "$_LABEL_VERSION"        == "" ]] && _LABEL_VERSION="v$_PROJECT_VERSION"
if [[ "$_LABEL_VCS_REF" == "" ]]; then
    _LABEL_VCS_REF=$(git describe --exact-match --tags HEAD 2> /dev/null)
    if [[ $? -ne 0 ]]; then
        _LABEL_VCS_REF=$(git rev-parse HEAD)
        _LABEL_USAGE="$_PROJECT_URL/blob/$_LABEL_VCS_REF/README.md"
    fi
fi
