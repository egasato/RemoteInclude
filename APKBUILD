# Maintainer: Esaú García Sánchez-Torija <egasato@protonmail.com>

#######################################################################
# Copyright (c) 2018 Esaú García Sánchez-Torija                       #
#                                                                     #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#######################################################################

## Define the package properties

_pkgname="RemoteInclude"
pkgname="remoteinclude"
subpackages=""

pkgver="1.0.0.1"
pkgrel=1

arch="noarch"
license="MPLv2"
pkgdesc="Remote CMake script downloader (and includer)"

pkgusers=""
pkggroups=""
depends="cmake"
depends_dev=""
makedepends="gcc make cmake"
install="${_pkgname}.pre-install ${_pkgname}.post-install ${_pkgname}.pre-upgrade ${_pkgname}.post-upgrade ${_pkgname}.pre-deinstall ${_pkgname}.post-deinstall"
install_if=""
options="!strip !tracedeps"
provides=""
provider_priority=""
replaces=""
replaces_priority=""
triggers=""

url="https://egasato.github.io/${_pkgname}"
giturl="https://github.com/egasato/${_pkgname}.git"
source="${pkgname}-${pkgver}.tar.gz::https://github.com/egasato/${_pkgname}/releases/download/v${pkgver}/${_pkgname}.tar.gz"
md5sums="dfa855e3deb8b886a38cc588462fe5cb  ${pkgname}-${pkgver}.tar.gz"
sha256sums="0aaed0c3288190dc4d8dadf092725e828c111eacef0b9013cb99998c286f1175  ${pkgname}-${pkgver}.tar.gz"
sha512sums="7349486bcdbc4387568775663e9a04d8b07ec4c7fa147ef8abe755a72209632c64d0247e1936048bb244594bd2229dd4dc32ecc8429c84ac3b334b4340e5be5c  ${pkgname}-${pkgver}.tar.gz"

builddir="${srcdir}/${_pkgname}"

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
    cd "$builddir/cmake-build-$type"
    cmake --build . --target install
}
