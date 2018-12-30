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
__apk="AKGBUILD"
__cmk="CMakeLists.txt"
__app=".appveyor.yml"
__abl=".abuild/abuild.conf"

## Generic function to use the get.pl script

function get_RPMBUILD() {
    "$__dirname/get.pl" RPMBUILD "$@" < "$__dirname/../$__spec" | dos2unix
}

function get_PKGBUILD() {
    "$__dirname/get.pl" PKGBUILD "$@" < "$__dirname/../$__pkg" | dos2unix
}

function get_APKBUILD() {
    "$__dirname/get.pl" APKBUILD "$@" < "$__dirname/../$__apk" | dos2unix
}

function get_CMAKE() {
    "$__dirname/get.pl" CMAKE "$@" < "$__dirname/../$__cmk" | dos2unix
}

function get_APPVEYOR() {
    "$__dirname/get.pl" APPVEYOR "$@" < "$__dirname/../$__app" | dos2unix
}

function get_DOCKER() {
    "$__dirname/get.pl" DOCKER "$@" < /dev/stdin | dos2unix
}

function get_ABUILD() {
    "$__dirname/get.pl" ABUILD "$@" < "$__dirname/../$__abl" | dos2unix
}

function get_LAUNCHER() {
    "$__dirname/get.pl" LAUNCHER "$@" < "$__dirname/../$1" | dos2unix
}

## Returns a specific part of the RPM spec file

function get_pkgname_RPMBUILD() {
    get_RPMBUILD pkgname
}

function get_name_RPMBUILD() {
    get_RPMBUILD Name
}

function get_version_RPMBUILD() {
    get_RPMBUILD Version
}

function get_summary_RPMBUILD() {
    get_RPMBUILD Summary
}

function get_license_RPMBUILD() {
    get_RPMBUILD License
}

function get_url_RPMBUILD() {
    get_RPMBUILD URL | perl -p -e "s/%\\{pkgname\\}/$1/g"
}

function get_source_RPMBUILD() {
    get_RPMBUILD Source0 | perl -p -e "s/%\\{pkgname\\}/$1/g" | perl -p -e "s/%\\{version\\}/$2/g"
}

function get_arch_RPMBUILD() {
    get_RPMBUILD BuildArch
}

function get_description_RPMBUILD() {
    get_RPMBUILD description
}

## Returns a specific part of the PKGBUILD file

function get__pkgname_PKGBUILD() {
    get_PKGBUILD _pkgname
}

function get_pkgname_PKGBUILD() {
    get_PKGBUILD pkgname
}

function get_version_PKGBUILD() {
    get_PKGBUILD pkgver
}

function get_license_PKGBUILD() {
    get_PKGBUILD license
}

function get_pkgdesc_PKGBUILD() {
    get_PKGBUILD pkgdesc
}

function get_url_PKGBUILD() {
    get_PKGBUILD url | perl -p -e "s/\\\$\\{_pkgname\\}/$1/g"
}

function get_source_PKGBUILD() {
    get_PKGBUILD source | sed -r 's/^([^:]*)::(.*)$/\2/' | perl -p -e "s/\\\$\\{_pkgname\\}/$1/g" | perl -p -e "s/\\\$\\{pkgver\\}/$2/g"
}

function get_md5_PKGBUILD() {
    get_PKGBUILD md5sums "$1"
}

function get_sha1_PKGBUILD() {
    get_PKGBUILD sha1sums "$1"
}

function get_sha224_PKGBUILD() {
    get_PKGBUILD sha224sums "$1"
}

function get_sha256_PKGBUILD() {
    get_PKGBUILD sha256sums "$1"
}

function get_sha384_PKGBUILD() {
    get_PKGBUILD sha384sums "$1"
}

function get_sha512_PKGBUILD() {
    get_PKGBUILD sha512sums "$1"
}

## Returns a specific part of the APKBUILD file

function get__pkgname_APKBUILD() {
    get_APKBUILD _pkgname
}

function get_pkgname_APKBUILD() {
    get_APKBUILD pkgname
}

function get_version_APKBUILD() {
    get_APKBUILD pkgver
}

function get_license_APKBUILD() {
    get_APKBUILD license
}

function get_pkgdesc_APKBUILD() {
    get_APKBUILD pkgdesc
}

function get_url_APKBUILD() {
    get_APKBUILD url | perl -p -e "s/\\\$\\{_pkgname\\}/$1/g"
}

function get_giturl_APKBUILD() {
    get_APKBUILD giturl | perl -p -e "s/\\\$\\{_pkgname\\}/$1/g"
}

function get_source_APKBUILD() {
    get_APKBUILD source | sed -r 's/^([^:]*)::(.*)$/\2/' | perl -p -e "s/\\\$\\{_pkgname\\}/$1/g" | perl -p -e "s/\\\$\\{pkgver\\}/$2/g"
}

function get_md5_APKBUILD() {
    get_APKBUILD md5sums "$1" | gawk '{print $1}'
}

function get_sha256_APKBUILD() {
    get_APKBUILD sha256sums "$1" | gawk '{print $1}'
}

function get_sha512_APKBUILD() {
    get_APKBUILD sha512sums "$1" | gawk '{print $1}'
}

## Returns a specific part of the CMakeLists.txt file

function get_name_CMAKE() {
    get_CMAKE PROJECT_NAME
}

function get_version_CMAKE() {
    get_CMAKE PROJECT_VERSION
}

function get_description_CMAKE() {
    get_CMAKE PROJECT_DESCRIPTION
}

function get_homepage_url_CMAKE() {
    get_CMAKE PROJECT_HOMEPAGE_URL
}

function get_vendor_CMAKE() {
    get_CMAKE CPACK_PACKAGE_VENDOR
}

function get_contact_CMAKE() {
    get_CMAKE CPACK_PACKAGE_CONTACT
}

function get_summary_CMAKE() {
    get_CMAKE CPACK_PACKAGE_DESCRIPTION_SUMMARY
}

## Returns a specific part of the AppVeyor file

function get_version_APPVEYOR() {
    get_APPVEYOR version
}

## Returns a specific part of the Dockerfile.* file

function get_author_user_DOCKER() {
    get_DOCKER AUTHOR_USER < "$1"
}

function get_author_name_DOCKER() {
    get_DOCKER AUTHOR_NAME < "$1"
}

function get_author_name_ascii_DOCKER() {
    get_DOCKER AUTHOR_NAME_ASCII < "$1"
}

function get_author_email_DOCKER() {
    get_DOCKER AUTHOR_EMAIL < "$1"
}

function get_project_name_DOCKER() {
    get_DOCKER PROJECT_NAME < "$1"
}

function get_project_description_DOCKER() {
    get_DOCKER PROJECT_DESCRIPTION < "$1"
}

function get_project_version_DOCKER() {
    get_DOCKER PROJECT_VERSION < "$1"
}

function get_project_sha512_DOCKER() {
    get_DOCKER PROJECT_SHA512 < "$1"
}

function get_author_contact_DOCKER() {
    get_DOCKER AUTHOR_CONTACT < "$1"
}

function get_author_contact_ascii_DOCKER() {
    get_DOCKER AUTHOR_CONTACT_ASCII < "$1"
}

function get_project_vendor_DOCKER() {
    get_DOCKER PROJECT_VENDOR < "$1"
}

function get_project_vendor_ascii_DOCKER() {
    get_DOCKER PROJECT_VENDOR_ASCII < "$1"
}

function get_project_homepage_DOCKER() {
    get_DOCKER PROJECT_HOMEPAGE < "$1"
}

function get_project_url_DOCKER() {
    get_DOCKER PROJECT_URL < "$1"
}

function get_project_vcs_DOCKER() {
    get_DOCKER PROJECT_VCS < "$1"
}

function get_project_source_DOCKER() {
    get_DOCKER PROJECT_SOURCE < "$1"
}

function get_cmake_build_type_DOCKER() {
    get_DOCKER CMAKE_BUILD_TYPE < "$1"
}

function get_label_build_date_DOCKER() {
    get_DOCKER LABEL_BUILD_DATE < "$1"
}

function get_label_name_DOCKER() {
    get_DOCKER LABEL_NAME < "$1"
}

function get_label_description_DOCKER() {
    get_DOCKER LABEL_DESCRIPTION < "$1"
}

function get_label_usage_DOCKER() {
    get_DOCKER LABEL_USAGE < "$1"
}

function get_label_url_DOCKER() {
    get_DOCKER LABEL_URL < "$1"
}

function get_label_vcs_url_DOCKER() {
    get_DOCKER LABEL_VCS_URL < "$1"
}

function get_label_vcs_ref_DOCKER() {
    get_DOCKER LABEL_VCS_REF < "$1"
}

function get_label_vendor_DOCKER() {
    get_DOCKER LABEL_VENDOR < "$1"
}

function get_label_version_DOCKER() {
    get_DOCKER LABEL_VERSION < "$1"
}

## Returns a specific part of the abuild.conf file

function get_packager_ABUILD() {
    get_ABUILD PACKAGER
}
