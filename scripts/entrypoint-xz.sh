#!/usr/bin/env bash

# Lint the PKGBUILD file
echo "================================================================================"
echo "===================================== LINT ====================================="
echo "================================================================================"
namcap PKGBUILD
echo

# Package the source of the project
echo "================================================================================"
echo "==================================== SOURCE ===================================="
echo "================================================================================"
makepkg --allsource
echo

# Package the project
echo "================================================================================"
echo "=================================== PACKAGE ===================================="
echo "================================================================================"
makepkg
echo

# Lint the packaged file
echo "================================================================================"
echo "===================================== LINT ====================================="
echo "================================================================================"
_proj=$(echo $PROJECT_NAME | tr 'A-Z' 'a-z' | tr -s ' ' | tr ' ' '-')
namcap $_proj-*-any.pkg.tar.xz
echo

# Copying created packages
echo "Copying artifacts"
_src="$(ls -1 | grep -E "^$_proj-$PROJECT_VERSION-[0-9]+\\.src\\.tar\\.gz\$")"
_bin="$(ls -1 | grep -E "^$_proj-$PROJECT_VERSION-[0-9]+-any\\.pkg\\.tar\\.xz\$")"
cp "$_src" "build/${CMAKE_BUILD_TYPE:-Release}"
cp "$_bin" "build/${CMAKE_BUILD_TYPE:-Release}"

unset _bin
unset _src
unset _proj

# Execute whatever the arguments are
if [[ $# -ge 0 ]] && [[ "$@" != "" ]]; then
    echo
    exec "$@"
fi
