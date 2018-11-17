# Maintainer: Esaú García Sánchez-Torija <egasato@protonmail.com>

#######################################################################
# Copyright (c) 2018 Esaú García Sánchez-Torija                       #
#                                                                     #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#######################################################################

pkgname="RemoteInclude"
pkgver="1.0.0.1"
pkgrel=1
pkgdesc="Simple CMake script to download and auto-include remote CMake scripts"
arch="noarch"
url="https://github.com/egasato/${pkgname}.git"
license="MPLv2"
depends=""
makedepends="cmake"
install=""
source="${pkgname}-${pkgver}.tar.gz::https://github.com/egasato/${pkgname}/releases/download/v${pkgver}/${pkgname}.tar.gz"
builddir="${srcdir}/${pkgname}-${pkgver}"

# Unpacks and configures the sources
prepare() {
	default_prepare
	local type=$(echo ${CMAKE_BUILD_TYPE:-Release} | tr '[A-Z]' '[a-z]')
    [ -d "$builddir/cmake-build-$type" ] || mkdir "$builddir/cmake-build-$type"
	cd "$builddir/cmake-build-$type"
    if [ "$CBUILD" != "$CHOST" ]; then
        CMAKE_CROSSOPTS="-D CMAKE_SYSTEM_NAME=Linux -D CMAKE_HOST_SYSTEM_NAME=Linux"
    fi
    cmake                                                \
        -D CMAKE_INSTALL_LIBDIR=lib                      \
        -D CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
        -D CMAKE_C_FLAGS="$CFLAGS"                       \
        -D CMAKE_INSTALL_PREFIX:PATH="$pkgdir/usr"       \
        ${CMAKE_CROSSOPTS}                               \
        "${builddir}"
}

# Compiles the project
build() {
    local type=$(echo ${CMAKE_BUILD_TYPE:-Release} | tr '[A-Z]' '[a-z]')
    [ -d "$builddir/cmake-build-$type" ] || mkdir "$builddir/cmake-build-$type"
	cd "$builddir/cmake-build-$type"
    cmake --build .
}

# Checks the project
check() {
    echo "This project has no tests :("
}

# Creates the package
package() {
    local type=$(echo ${CMAKE_BUILD_TYPE:-Release} | tr '[A-Z]' '[a-z]')
    [ -d "$builddir/cmake-build-$type" ] || mkdir "$builddir/cmake-build-$type"
	cd "$builddir/cmake-build-$type"
    cmake --build . --target install
}

sha512sums="3421692bd9d341c1820e9150e0ecb813c2c1804c47bac7fcf7b724e6c62ce4d946c04564879723fec06681c0ff88b049527fd3c4a0245b0398851ec407c72122 RemoteInclude.tar.gz"
