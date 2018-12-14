#!/usr/bin/env sh

# Change directory to prevent polluting the source code
_proj=$(echo $PROJECT_NAME | tr 'A-Z' 'a-z' | tr -s ' ' | tr ' ' '-')
_prev="$(pwd)"
_next="/usr/src/aports/community/$_proj"
echo "Changing to build directory: $_next"
[ -d "$_next" ] || mkdir -p "$_next"
cd "$_next"

# Link the APKBUILD
echo "Copying APKBUILD"
cp "$_prev/APKBUILD" "$_next/APKBUILD"

# Fetch the sources (will success even if they do not exist)
echo "================================================================================"
echo "==================================== FETCH ====================================="
echo "================================================================================"
abuild -c -K fetch
echo

# Create the source package
echo "================================================================================"
echo "=================================== SOURCE ====================================="
echo "================================================================================"
abuild -c -K srcpkg
echo

# Unpack the source code
echo "================================================================================"
echo "=================================== UNPACK ====================================="
echo "================================================================================"
abuild -c -K unpack
echo

# Prepare the project
echo "================================================================================"
echo "=================================== PREPARE ===================================="
echo "================================================================================"
abuild -c -K prepare
echo

# Create the binary package
echo "================================================================================"
echo "=================================== BINARY ====================================="
echo "================================================================================"
abuild -c -K rootpkg
echo

# Copying created packages
echo "Copying artifacts"
_src="$(ls -1 "$HOME/packages/src"                    | grep -E "^$_proj-$PROJECT_VERSION-\\d+\\.src\\.tar\\.gz\$")"
_bin="$(ls -1 "$HOME/packages/community/$(abuild -A)" | grep -E "^$_proj-$PROJECT_VERSION-r\\d+\\.apk\$")"
cp "$HOME/packages/src/$_src"                    "$_prev/build/${CMAKE_BUILD_TYPE:-Release}"
cp "$HOME/packages/community/$(abuild -A)/$_bin" "$_prev/build/${CMAKE_BUILD_TYPE:-Release}"

# Change directory to prevent polluting the source code
echo "Changing to previous directory: $_prev"
cd "$_prev"
unset _bin
unset _src
unset _next
unset _prev
unset _proj

# Execute whatever the arguments are
if [[ $# -ge 0 ]] && [[ "$@" != "" ]]; then
    echo
    exec "$@"
fi
