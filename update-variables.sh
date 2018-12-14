#!/usr/bin/env bash

# Load all the project properties
source project.properties.sh

# Printing functions
source scripts/ok.sh
source scripts/ko.sh

## CMakeLists functions

source scripts/get_version_CMakeLists.sh
source scripts/set_version_CMakeLists.sh

source scripts/get_description_CMakeLists.sh
source scripts/set_description_CMakeLists.sh

source scripts/get_homepage_CMakeLists.sh
source scripts/set_homepage_CMakeLists.sh

source scripts/get_vendor_CMakeLists.sh
source scripts/set_vendor_CMakeLists.sh

source scripts/get_contact_CMakeLists.sh
source scripts/set_contact_CMakeLists.sh

source scripts/get_summary_CMakeLists.sh
source scripts/set_summary_CMakeLists.sh

# AppVeyor functions
source scripts/get_version_AppVeyor.sh
source scripts/set_version_AppVeyor.sh

## Fedora functions

source scripts/get_name_RPM.sh
source scripts/set_name_RPM.sh

source scripts/get_version_RPM.sh
source scripts/set_version_RPM.sh

## Arch Linux functions

source scripts/get_name_PKGBUILD.sh
source scripts/set_name_PKGBUILD.sh

source scripts/get_version_PKGBUILD.sh
source scripts/set_version_PKGBUILD.sh

source scripts/get_description_PKGBUILD.sh
source scripts/set_description_PKGBUILD.sh

source scripts/get_url_PKGBUILD.sh
source scripts/set_url_PKGBUILD.sh

source scripts/get_source_PKGBUILD.sh
source scripts/set_source_PKGBUILD.sh

source scripts/get_md5_PKGBUILD.sh
source scripts/set_md5_PKGBUILD.sh

source scripts/get_sha1_PKGBUILD.sh
source scripts/set_sha1_PKGBUILD.sh

source scripts/get_sha224_PKGBUILD.sh
source scripts/set_sha224_PKGBUILD.sh

source scripts/get_sha256_PKGBUILD.sh
source scripts/set_sha256_PKGBUILD.sh

source scripts/get_sha384_PKGBUILD.sh
source scripts/set_sha384_PKGBUILD.sh

source scripts/get_sha512_PKGBUILD.sh
source scripts/set_sha512_PKGBUILD.sh

source scripts/set_args_xz.sh
#source scripts/set_launcher_apk.sh

## Alpine Linux functions

source scripts/get_name_APKBUILD.sh
source scripts/set_name_APKBUILD.sh

source scripts/get_version_APKBUILD.sh
source scripts/set_version_APKBUILD.sh

source scripts/get_description_APKBUILD.sh
source scripts/set_description_APKBUILD.sh

source scripts/get_url_APKBUILD.sh
source scripts/set_url_APKBUILD.sh

source scripts/get_source_APKBUILD.sh
source scripts/set_source_APKBUILD.sh

source scripts/get_sha512_APKBUILD.sh
source scripts/set_sha512_APKBUILD.sh

source scripts/get_packager_abuild.sh
source scripts/set_packager_abuild.sh

source scripts/set_args_apk.sh
source scripts/set_launcher_apk.sh

## Logic

# Update the version number
echo "Updating files":

if [[ -f CMakeLists.txt ]]; then
    echo -n "* CMakeLists.txt (version number): "
    if [[ "$(get_version_CMakeLists)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_CMakeLists "$_PROJECT_VERSION"
        [[ "$(get_version_CMakeLists)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (description):    "
    if [[ "$(get_description_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]]; then
        ok
    else
        set_description_CMakeLists "$_PROJECT_DESCRIPTION"
        [[ "$(get_description_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (homepage):       "
    if [[ "$(get_homepage_CMakeLists)" == "$_PROJECT_URL" ]]; then
        ok
    else
        set_homepage_CMakeLists "$_PROJECT_URL"
        [[ "$(get_homepage_CMakeLists)" == "$_PROJECT_URL" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (vendor):         "
    if [[ "$(get_vendor_CMakeLists)" == "$_PROJECT_VENDOR_ASCII" ]]; then
        ok
    else
        set_vendor_CMakeLists "$_PROJECT_VENDOR_ASCII"
        [[ "$(get_vendor_CMakeLists)" == "$_PROJECT_VENDOR_ASCII" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (contact):        "
    if [[ "$(get_contact_CMakeLists)" == "$_AUTHOR_CONTACT" ]]; then
        ok
    else
        set_contact_CMakeLists "$_AUTHOR_CONTACT"
        [[ "$(get_contact_CMakeLists)" == "$_AUTHOR_CONTACT" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (summary):        "
    if [[ "$(get_summary_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]]; then
        ok
    else
        set_summary_CMakeLists "$_PROJECT_DESCRIPTION"
        [[ "$(get_summary_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
    fi
fi

if [[ -f .appveyor.yml ]]; then
    echo -n "* .appveyor.yml (version):         "
    if [[ "$(get_version_AppVeyor)" == "$_PROJECT_VERSION-{build}" ]]; then
        ok
    else
        set_version_AppVeyor "$_PROJECT_VERSION"
        [[ "$(get_version_AppVeyor)" == "$_PROJECT_VERSION-{build}" ]] && ok || ko
    fi
fi

if [[ -f PKGBUILD ]]; then
    echo -n "* PKGBUILD (name):                 "
    if [[ "$(get_name_PKGBUILD)" == "$_PROJECT_NAME" ]]; then
        ok
    else
        set_name_PKGBUILD "$_PROJECT_NAME"
        [[ "$(get_name_PKGBUILD)" == "$_PROJECT_NAME" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (version):              "
    if [[ "$(get_version_PKGBUILD)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_PKGBUILD "$_PROJECT_VERSION"
        [[ "$(get_version_PKGBUILD)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (description):          "
    if [[ "$(get_description_PKGBUILD)" == "$_PROJECT_DESCRIPTION" ]]; then
        ok
    else
        set_description_PKGBUILD "$_PROJECT_DESCRIPTION"
        [[ "$(get_description_PKGBUILD)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (url):                  "
    if [[ "$(get_url_PKGBUILD "$_PROJECT_NAME")" == "$_PROJECT_VCS" ]]; then
        ok
    else
        set_url_PKGBUILD "$_PROJECT_VCS" "$_PROJECT_NAME"
        [[ "$(get_url_PKGBUILD "$_PROJECT_NAME")" == "$_PROJECT_VCS" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (source):               "
    if [[ "$(get_source_PKGBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]]; then
        ok
    else
        set_source_PKGBUILD "$_PROJECT_SOURCE" "$_PROJECT_NAME" "$_PROJECT_VERSION"
        [[ "$(get_source_PKGBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (md5):                  "
    if [[ "$(get_md5_PKGBUILD)" == "$_PROJECT_MD5" ]]; then
        ok
    else
        set_md5_PKGBUILD "$_PROJECT_MD5"
        [[ "$(get_md5_PKGBUILD)" == "$_PROJECT_MD5" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha1):                 "
    if [[ "$(get_sha1_PKGBUILD)" == "$_PROJECT_SHA1" ]]; then
        ok
    else
        set_sha1_PKGBUILD "$_PROJECT_SHA1"
        [[ "$(get_sha1_PKGBUILD)" == "$_PROJECT_SHA1" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha224):               "
    if [[ "$(get_sha224_PKGBUILD)" == "$_PROJECT_SHA224" ]]; then
        ok
    else
        set_sha224_PKGBUILD "$_PROJECT_SHA224"
        [[ "$(get_sha224_PKGBUILD)" == "$_PROJECT_SHA224" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha256):               "
    if [[ "$(get_sha256_PKGBUILD)" == "$_PROJECT_SHA256" ]]; then
        ok
    else
        set_sha256_PKGBUILD "$_PROJECT_SHA256"
        [[ "$(get_sha256_PKGBUILD)" == "$_PROJECT_SHA256" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha384):               "
    if [[ "$(get_sha384_PKGBUILD)" == "$_PROJECT_SHA384" ]]; then
        ok
    else
        set_sha384_PKGBUILD "$_PROJECT_SHA384"
        [[ "$(get_sha384_PKGBUILD)" == "$_PROJECT_SHA384" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha512):               "
    if [[ "$(get_sha512_PKGBUILD)" == "$_PROJECT_SHA512" ]]; then
        ok
    else
        set_sha512_PKGBUILD "$_PROJECT_SHA512"
        [[ "$(get_sha512_PKGBUILD)" == "$_PROJECT_SHA512" ]] && ok || ko
    fi
fi

if [[ -f Dockerfile.xz ]]; then
    echo -n "* Dockerfile.xz (args):            "
    set_args_xz \
        "$_AUTHOR_USER"      "$_AUTHOR_NAME"         "$_AUTHOR_NAME_ASCII" "$_AUTHOR_EMAIL"   "$_AUTHOR_CONTACT" "$_AUTHOR_CONTACT_ASCII"                                                                                  \
        "$_PROJECT_NAME"     "$_PROJECT_DESCRIPTION" "$_PROJECT_VERSION"   "$_PROJECT_SHA512" "$_PROJECT_VENDOR" "$_PROJECT_VENDOR_ASCII" "$_PROJECT_HOMEPAGE" "$_PROJECT_URL"  "$_PROJECT_VCS"   "$_PROJECT_SOURCE" \
        "$_LABEL_BUILD_DATE" "$_LABEL_NAME"          "$_LABEL_DESCRIPTION" "$_LABEL_USAGE"    "$_LABEL_URL"      "$_LABEL_VCS_URL"        "$_LABEL_VCS_REF"    "$_LABEL_VENDOR" "$_LABEL_VERSION"
    ok
fi

if [[ -f APKBUILD ]]; then
    echo -n "* APKBUILD (name):                 "
    if [[ "$(get_name_APKBUILD)" == "$_PROJECT_NAME" ]]; then
        ok
    else
        set_name_APKBUILD "$_PROJECT_NAME"
        [[ "$(get_name_APKBUILD)" == "$_PROJECT_NAME" ]] && ok || ko
    fi

    echo -n "* APKBUILD (version):              "
    if [[ "$(get_version_APKBUILD)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_APKBUILD "$_PROJECT_VERSION"
        [[ "$(get_version_APKBUILD)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* APKBUILD (description):          "
    if [[ "$(get_description_APKBUILD)" == "$_PROJECT_DESCRIPTION" ]]; then
        ok
    else
        set_description_APKBUILD "$_PROJECT_DESCRIPTION"
        [[ "$(get_description_APKBUILD)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
    fi

    echo -n "* APKBUILD (url):                  "
    if [[ "$(get_url_APKBUILD "$_PROJECT_NAME")" == "$_PROJECT_VCS" ]]; then
        ok
    else
        set_url_APKBUILD "$_PROJECT_VCS" "$_PROJECT_NAME"
        [[ "$(get_url_APKBUILD "$_PROJECT_NAME")" == "$_PROJECT_VCS" ]] && ok || ko
    fi

    echo -n "* APKBUILD (source):               "
    if [[ "$(get_source_APKBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]]; then
        ok
    else
        set_source_APKBUILD "$_PROJECT_SOURCE" "$_PROJECT_NAME" "$_PROJECT_VERSION"
        [[ "$(get_source_APKBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]] && ok || ko
    fi

    echo -n "* APKBUILD (sha512):               "
    if [[ "$(get_sha512_APKBUILD)" == "$_PROJECT_SHA512" ]]; then
        ok
    else
        set_sha512_APKBUILD "$_PROJECT_SHA512" "$_PROJECT_NAME" "$_PROJECT_VERSION"
        [[ "$(get_sha512_APKBUILD)" == "$_PROJECT_SHA512" ]] && ok || ko
    fi
fi

if [[ -f .abuild/abuild.conf ]]; then
    echo -n "* abuild.conf (packager):          "
    if [[ "$(get_packager_abuild)" == "$_AUTHOR_CONTACT" ]]; then
        ok
    else
        set_packager_abuild "$_AUTHOR_CONTACT"
        [[ "$(get_packager_abuild)" == "$_AUTHOR_CONTACT" ]] && ok || ko
    fi
fi

if [[ -f Dockerfile.apk ]]; then
    echo -n "* Dockerfile.apk (args):           "
    set_args_apk \
        "$_AUTHOR_USER"      "$_AUTHOR_NAME"         "$_AUTHOR_NAME_ASCII" "$_AUTHOR_EMAIL"   "$_AUTHOR_CONTACT" "$_AUTHOR_CONTACT_ASCII"                                                                                  \
        "$_PROJECT_NAME"     "$_PROJECT_DESCRIPTION" "$_PROJECT_VERSION"   "$_PROJECT_SHA512" "$_PROJECT_VENDOR" "$_PROJECT_VENDOR_ASCII" "$_PROJECT_HOMEPAGE" "$_PROJECT_URL"  "$_PROJECT_VCS"   "$_PROJECT_SOURCE" \
        "$_LABEL_BUILD_DATE" "$_LABEL_NAME"          "$_LABEL_DESCRIPTION" "$_LABEL_USAGE"    "$_LABEL_URL"      "$_LABEL_VCS_URL"        "$_LABEL_VCS_REF"    "$_LABEL_VENDOR" "$_LABEL_VERSION"
    ok
fi

if [[ -f docker-apk.sh ]]; then
    echo -n "* docker-apk.sh (name):            "
    set_launcher_apk "$_PROJECT_NAME"
    ok
fi