# Maintainer: Esaú García Sánchez-Torija <egasato@protonmail.com>

#######################################################################
# Copyright (c) 2018 Esaú García Sánchez-Torija                       #
#                                                                     #
# This Source Code Form is subject to the terms of the Mozilla Public #
# License, v. 2.0. If a copy of the MPL was not distributed with this #
# file, You can obtain one at http://mozilla.org/MPL/2.0/.            #
#######################################################################

_pkgname="RemoteInclude"
pkgname="remoteinclude"

pkgver="1.0.0.1"
pkgrel=1
epoch=0

arch=("any")
license=("MPL2")
pkgdesc="Remote CMake script downloader (and includer)"
groups=()

depends=()
makedepends=()
optdepends=()
checkdepends=("cmake")
provides=()
conflicts=()
replaces=()
backup=()
options=()
install=""
changelog=""

url="https://egasato.github.io/${_pkgname}"
source=("${pkgname}-${pkgver}.tar.gz::https://github.com/egasato/${_pkgname}/releases/download/v${pkgver}/${_pkgname}.tar.gz")
noextract=()
md5sums=("dfa855e3deb8b886a38cc588462fe5cb")
sha1sums=("7fbcb04ed0559cdbd6442bc584b576cd04bc03d7")
sha224sums=("53de9edae6e9dc3b712e51e6f6c081af294aaa063dea43a92c5c8411")
sha256sums=("0aaed0c3288190dc4d8dadf092725e828c111eacef0b9013cb99998c286f1175")
sha384sums=("b8420cf714f37588e6f1e833655aeb5d721bc9e12d7c93a88c7fd91ce4a8fae83b1b26fc468df02fbe260ceeab9d9be7")
sha512sums=("7349486bcdbc4387568775663e9a04d8b07ec4c7fa147ef8abe755a72209632c64d0247e1936048bb244594bd2229dd4dc32ecc8429c84ac3b334b4340e5be5c")

# Unpacks and configures the sources
prepare() {
	local type=$(echo ${CMAKE_BUILD_TYPE:-Release} | tr '[A-Z]' '[a-z]')
    [ -d "${_pkgname}/cmake-build-$type" ] || mkdir "${_pkgname}/cmake-build-$type"
	cd "${_pkgname}/cmake-build-$type"
    if [ "$CBUILD" != "$CHOST" ]; then
        CMAKE_CROSSOPTS="-D CMAKE_SYSTEM_NAME=Linux -D CMAKE_HOST_SYSTEM_NAME=Linux"
    fi
    cmake                                                \
        -D CMAKE_INSTALL_LIBDIR=lib                      \
        -D CMAKE_BUILD_TYPE=${CMAKE_BUILD_TYPE:-Release} \
        -D CMAKE_C_FLAGS="$CFLAGS"                       \
        -D CMAKE_INSTALL_PREFIX:PATH="$pkgdir/usr"       \
        ${CMAKE_CROSSOPTS}                               \
        ".."
}

# Compiles the project
build() {
    local type=$(echo ${CMAKE_BUILD_TYPE:-Release} | tr '[A-Z]' '[a-z]')
	[ -d "${_pkgname}/cmake-build-$type" ] || mkdir "${_pkgname}/cmake-build-$type"
	cd "${_pkgname}/cmake-build-$type"
    cmake --build .
}

# Checks the project
check() {
	echo "This project has no tests :("
}

# Creates the package
package() {
    local type=$(echo ${CMAKE_BUILD_TYPE:-Release} | tr '[A-Z]' '[a-z]')
	[ -d "${_pkgname}/cmake-build-$type" ] || mkdir "${_pkgname}/cmake-build-$type"
	cd "${_pkgname}/cmake-build-$type"
    cmake --build . --target install
}
