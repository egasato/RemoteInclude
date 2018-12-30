#!/usr/bin/env bash

# Get the current location
if [[ "${BASH_SOURCE[0]}" == "" ]]; then
    __filename=$(cd "$(dirname "$0")" && pwd -P)/$(basename "$0")
else
    __filename=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)/$(basename "${BASH_SOURCE[0]}")
fi
__dirname=$(dirname "$__filename")
__spec=$(ls -1 "$__dirname/.." | grep -E "^*.spec$")
__pkg="PKGBUILD"
__apk="APKBUILD"
__cmk="CMakeLists.txt"
__app=".appveyor.yml"
__abl=".abuild/abuild.conf"

## Generic function to use the get.pl script

function set_RPMBUILD() {
    "$__dirname/set.pl" RPMBUILD "$@" < "$__dirname/../$__spec" | dos2unix > "$__dirname/../$__spec.tmp"
    mv "$__dirname/../$__spec.tmp" "$__dirname/../$__spec"
}

function set_PKGBUILD() {
    "$__dirname/set.pl" PKGBUILD "$@" < "$__dirname/../$__pkg" | dos2unix > "$__dirname/../$__pkg.tmp"
    mv "$__dirname/../$__pkg.tmp" "$__dirname/../$__pkg"
}

function set_APKBUILD() {
    "$__dirname/set.pl" APKBUILD "$@" < "$__dirname/../$__apk" | dos2unix > "$__dirname/../$__apk.tmp"
    mv "$__dirname/../$__apk.tmp" "$__dirname/../$__apk"
}

function set_CMAKE() {
    "$__dirname/set.pl" CMAKE "$@" < "$__dirname/../$__cmk" | dos2unix > "$__dirname/../$__cmk.tmp"
    mv "$__dirname/../$__cmk.tmp" "$__dirname/../$__cmk"
}

function set_APPVEYOR() {
    "$__dirname/set.pl" APPVEYOR "$@" < "$__dirname/../$__app" | dos2unix > "$__dirname/../$__app.tmp"
    mv "$__dirname/../$__app.tmp" "$__dirname/../$__app"
}

function set_DOCKER() {
    "$__dirname/set.pl" DOCKER "$@" < /dev/stdin | dos2unix
}

function set_ABUILD() {
    "$__dirname/set.pl" ABUILD "$@" < "$__dirname/../$__abl" | dos2unix > "$__dirname/../$__abl.tmp"
    mv "$__dirname/../$__abl.tmp" "$__dirname/../$__abl"
}

function set_LAUNCHER() {
    "$__dirname/set.pl" LAUNCHER "$@" < "$__dirname/../$1" | dos2unix > "$__dirname/../$1.tmp"
    mv "$__dirname/../$1.tmp" "$__dirname/../$1"
}

## Sets a specific part of the RPM spec file

function set_pkgname_RPMBUILD() {
    set_RPMBUILD pkgname "$1"
}

function set_name_RPMBUILD() {
    set_RPMBUILD Name "$1"
}

function set_version_RPMBUILD() {
    set_RPMBUILD Version "$1"
}

function set_summary_RPMBUILD() {
    set_RPMBUILD Summary "$1"
}

function set_license_RPMBUILD() {
    set_RPMBUILD License "$1"
}

function set_url_RPMBUILD() {
    set_RPMBUILD URL "$(echo "$1" | perl -p -e "s/\\Q$2\\E/%{pkgname}/g")"
}

function set_source_RPMBUILD() {
    set_RPMBUILD Source0 "$(echo "$1" | perl -p -e "s/\\Q$2\\E/%{pkgname}/g" | perl -p -e "s/\\Q$3\\E/%{version}/g")"
}

function set_arch_RPMBUILD() {
    set_RPMBUILD BuildArch "$1"
}

function set_description_RPMBUILD() {
    set_RPMBUILD description "$1"
}

## Sets a specific part of the PKGBUILD file

function set__pkgname_PKGBUILD() {
    set_PKGBUILD _pkgname "$1"
}

function set_pkgname_PKGBUILD() {
    set_PKGBUILD pkgname "$1"
}

function set_version_PKGBUILD() {
    set_PKGBUILD pkgver "$1"
}

function set_license_PKGBUILD() {
    set_PKGBUILD license "$1"
}

function set_pkgdesc_PKGBUILD() {
    set_PKGBUILD pkgdesc "$1"
}

function set_url_PKGBUILD() {
    set_PKGBUILD url "$(echo "$1" | perl -p -e "s/\\Q$2\\E/\\\${_pkgname}/g")"
}

function set_source_PKGBUILD() {
    set_PKGBUILD source "$(echo "\${pkgname}-\${pkgver}.tar.gz::$1" | perl -p -e "s/\\Q$2\\E/\\\${_pkgname}/g" | perl -p -e "s/\\Q$3\\E/\\\${pkgver}/g")"
}

function set_md5_PKGBUILD() {
    set_PKGBUILD md5sums "$1"
}

function set_sha1_PKGBUILD() {
    set_PKGBUILD sha1sums "$1"
}

function set_sha224_PKGBUILD() {
    set_PKGBUILD sha224sums "$1"
}

function set_sha256_PKGBUILD() {
    set_PKGBUILD sha256sums "$1"
}

function set_sha384_PKGBUILD() {
    set_PKGBUILD sha384sums "$1"
}

function set_sha512_PKGBUILD() {
    set_PKGBUILD sha512sums "$1"
}

## Sets a specific part of the APKBUILD file

function set__pkgname_APKBUILD() {
    set_APKBUILD _pkgname "$1"
}

function set_pkgname_APKBUILD() {
    set_APKBUILD pkgname "$1"
}

function set_version_APKBUILD() {
    set_APKBUILD pkgver "$1"
}

function set_license_APKBUILD() {
    set_APKBUILD license "$1"
}

function set_pkgdesc_APKBUILD() {
    set_APKBUILD pkgdesc "$1"
}

function set_url_APKBUILD() {
    set_APKBUILD url "$(echo "$1" | perl -p -e "s/\\Q$2\\E/\\\${_pkgname}/g")"
}

function set_giturl_APKBUILD() {
    set_APKBUILD giturl "$(echo "$1" | perl -p -e "s/\\Q$2\\E/\\\${_pkgname}/g")"
}

function set_source_APKBUILD() {
    set_APKBUILD source "$(echo "\${pkgname}-\${pkgver}.tar.gz::$1" | perl -p -e "s/\\Q$2\\E/\\\${_pkgname}/g" | perl -p -e "s/\\Q$3\\E/\\\${pkgver}/g")"
}

function set_md5_APKBUILD() {
    set_APKBUILD md5sums "$1  \${pkgname}-\${pkgver}.tar.gz"
}

function set_sha256_APKBUILD() {
    set_APKBUILD sha256sums "$1  \${pkgname}-\${pkgver}.tar.gz"
}

function set_sha512_APKBUILD() {
    set_APKBUILD sha512sums "$1  \${pkgname}-\${pkgver}.tar.gz"
}

## Sets a specific part of the CMakeLists.txt file

function set_name_CMAKE() {
    set_CMAKE PROJECT_NAME "$1"
}

function set_version_CMAKE() {
    set_CMAKE PROJECT_VERSION "$1"
}

function set_description_CMAKE() {
    set_CMAKE PROJECT_DESCRIPTION "$1"
}

function set_homepage_url_CMAKE() {
    set_CMAKE PROJECT_HOMEPAGE_URL "$1"
}

function set_vendor_CMAKE() {
    set_CMAKE CPACK_PACKAGE_VENDOR "$1"
}

function set_contact_CMAKE() {
    set_CMAKE CPACK_PACKAGE_CONTACT "$1"
}

function set_summary_CMAKE() {
    set_CMAKE CPACK_PACKAGE_DESCRIPTION_SUMMARY "$1"
}

## Sets a specific part of the AppVeyor file

function set_version_APPVEYOR() {
    set_APPVEYOR version "$1"
}

## Sets a specific part of the Dockerfile.* file

function set_author_user_DOCKER() {
    set_DOCKER AUTHOR_USER "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_author_name_DOCKER() {
    set_DOCKER AUTHOR_NAME "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_author_name_ascii_DOCKER() {
    set_DOCKER AUTHOR_NAME_ASCII "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_author_email_DOCKER() {
    set_DOCKER AUTHOR_EMAIL "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_name_DOCKER() {
    set_DOCKER PROJECT_NAME "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_description_DOCKER() {
    set_DOCKER PROJECT_DESCRIPTION "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_version_DOCKER() {
    set_DOCKER PROJECT_VERSION "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_sha512_DOCKER() {
    set_DOCKER PROJECT_SHA512 "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_author_contact_DOCKER() {
    set_DOCKER AUTHOR_CONTACT "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_author_contact_ascii_DOCKER() {
    set_DOCKER AUTHOR_CONTACT_ASCII "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_vendor_DOCKER() {
    set_DOCKER PROJECT_VENDOR "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_vendor_ascii_DOCKER() {
    set_DOCKER PROJECT_VENDOR_ASCII "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_homepage_DOCKER() {
    set_DOCKER PROJECT_HOMEPAGE "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_url_DOCKER() {
    set_DOCKER PROJECT_URL "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_vcs_DOCKER() {
    set_DOCKER PROJECT_VCS "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_project_source_DOCKER() {
    set_DOCKER PROJECT_SOURCE "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_cmake_build_type_DOCKER() {
    set_DOCKER CMAKE_BUILD_TYPE "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_build_date_DOCKER() {
    set_DOCKER LABEL_BUILD_DATE "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_name_DOCKER() {
    set_DOCKER LABEL_NAME "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_description_DOCKER() {
    set_DOCKER LABEL_DESCRIPTION "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_usage_DOCKER() {
    set_DOCKER LABEL_USAGE "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_url_DOCKER() {
    set_DOCKER LABEL_URL "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_vcs_url_DOCKER() {
    set_DOCKER LABEL_VCS_URL "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_vcs_ref_DOCKER() {
    set_DOCKER LABEL_VCS_REF "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_vendor_DOCKER() {
    set_DOCKER LABEL_VENDOR "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

function set_label_version_DOCKER() {
    set_DOCKER LABEL_VERSION "$2" < "$1" > "$1.tmp"
    mv "$1.tmp" "$1"
}

## Returns a specific part of the abuild.conf file

function set_packager_ABUILD() {
    set_ABUILD PACKAGER "$1"
}
