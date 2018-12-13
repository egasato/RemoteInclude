#!/usr/bin/env bash

# Get the absolute path of the script
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")
__name=$(basename "$__filename" ".sh")

# Check if the Config::Properties module is installed (perl)
if ! perldoc -l Config::Properties > /dev/null 2>&1; then
    PERL_MM_USE_DEFAULT=1 cpan install Config::Properties
fi

# Read everything using Perl
declare -a _ULTRA_PRIVATE
while IFS= read -rd '' key && IFS= read -rd '' value; do
    eval "_ULTRA_PRIVATE_${key}='$value'"
    _ULTRA_PRIVATE+=("$key")
done < <(
    perl -MConfig::Properties -l0 -e '
        $p = Config::Properties->new();
        $p->load(STDIN);
        print for $p->properties
    ' < "$__dirname/$__name"
)

# Remove previous variables
unset __filename
unset __dirname
unset __name
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
[[ "$_PROJECT_SOURCE"       == "" ]] && _PROJECT_SOURCE="https://github.com/$_AUTHOR_USER/$_PROJECT_NAME/releases/download/v$_PROJECT_VERSION/$_PROJECT_NAME.tar.gz"
[[ "$_PROJECT_MD5"          == "" ]] && _PROJECT_MD5=$(md5sum "build/${CMAKE_BUILD_TYPE:-Release}/$_PROJECT_NAME.tar.gz" 2> /dev/null | cut -d' ' -f1)
[[ "$_PROJECT_SHA1"         == "" ]] && _PROJECT_SHA1=$(sha1sum "build/${CMAKE_BUILD_TYPE:-Release}/$_PROJECT_NAME.tar.gz" 2> /dev/null | cut -d' ' -f1)
[[ "$_PROJECT_SHA224"       == "" ]] && _PROJECT_SHA224=$(sha224sum "build/${CMAKE_BUILD_TYPE:-Release}/$_PROJECT_NAME.tar.gz" 2> /dev/null | cut -d' ' -f1)
[[ "$_PROJECT_SHA256"       == "" ]] && _PROJECT_SHA256=$(sha256sum "build/${CMAKE_BUILD_TYPE:-Release}/$_PROJECT_NAME.tar.gz" 2> /dev/null | cut -d' ' -f1)
[[ "$_PROJECT_SHA384"       == "" ]] && _PROJECT_SHA384=$(sha384sum "build/${CMAKE_BUILD_TYPE:-Release}/$_PROJECT_NAME.tar.gz" 2> /dev/null | cut -d' ' -f1)
[[ "$_PROJECT_SHA512"       == "" ]] && _PROJECT_SHA512=$(sha512sum "build/${CMAKE_BUILD_TYPE:-Release}/$_PROJECT_NAME.tar.gz" 2> /dev/null | cut -d' ' -f1)
[[ "$_LABEL_BUILD_DATE"     == "" ]] && _LABEL_BUILD_DATE="$(date +%FT%T.%NZ)"
[[ "$_LABEL_NAME"           == "" ]] && _LABEL_NAME="$_PROJECT_NAME"
[[ "$_LABEL_DESCRIPTION"    == "" ]] && _LABEL_DESCRIPTION="$_PROJECT_DESCRIPTION"
[[ "$_LABEL_USAGE"          == "" ]] && _LABEL_USAGE="$_PROJECT_URL/blob/v$_PROJECT_VERSION/README.md"
[[ "$_LABEL_URL"            == "" ]] && _LABEL_URL="$_PROJECT_HOMEPAGE"
[[ "$_LABEL_VCS_URL"        == "" ]] && _LABEL_VCS_URL="$_PROJECT_VCS"
[[ "$_LABEL_VENDOR"         == "" ]] && _LABEL_VENDOR="$_PROJECT_VENDOR"
[[ "$_LABEL_VERSION"        == "" ]] && _LABEL_VERSION="v$_PROJECT_VERSION"

# Fix variables
if [[ "$_LABEL_VCS_REF" == "" ]]; then
    _LABEL_VCS_REF=$(git describe --exact-match --tags HEAD 2> /dev/null)
    if [[ $? -ne 0 ]]; then
        _LABEL_VCS_REF=$(git rev-parse HEAD)
        _LABEL_USAGE="$_PROJECT_URL/blob/$_LABEL_VCS_REF/README.md"
    fi
fi
if [[ "$_PROJECT_SHA512" == "" ]]; then
    _PROJECT_SHA512="00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
fi
