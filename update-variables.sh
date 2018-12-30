#!/usr/bin/env bash

# Load all the project properties
source project.properties.sh

# Printing functions
source scripts/ok.sh
source scripts/ko.sh

# Value getter/setter functions
source scripts/get.sh
source scripts/set.sh

# Update the variables
echo "Updating files":

if [[ -f remoteinclude.spec ]]; then
    echo -n "* remoteinclude.spec (pkgname):                       "
    if [[ "$(get_pkgname_RPMBUILD)" == "$_PROJECT_NAME" ]]; then
        ok
    else
        set_pkgname_RPMBUILD "$_PROJECT_NAME"
        [[ "$(get_pkgname_RPMBUILD)" == "$_PROJECT_NAME" ]] && ok || ko
    fi

    echo -n "* remoteinclude.spec (Name):                          "
    if [[ "$(get_name_RPMBUILD)" == "$_PROJECT_NAME_LOWER" ]]; then
        ok
    else
        set_name_RPMBUILD "$_PROJECT_NAME_LOWER"
        [[ "$(get_name_RPMBUILD)" == "$_PROJECT_NAME_LOWER" ]] && ok || ko
    fi

    echo -n "* remoteinclude.spec (version):                       "
    if [[ "$(get_version_RPMBUILD)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_RPMBUILD "$_PROJECT_VERSION"
        [[ "$(get_version_RPMBUILD)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* remoteinclude.spec (summary):                       "
    if [[ "$(get_summary_RPMBUILD)" == "$_PROJECT_SUMMARY" ]]; then
        ok
    else
        set_summary_RPMBUILD "$_PROJECT_SUMMARY"
        [[ "$(get_summary_RPMBUILD)" == "$_PROJECT_SUMMARY" ]] && ok || ko
    fi

    echo -n "* remoteinclude.spec (url):                           "
    if [[ "$(get_url_RPMBUILD "$_PROJECT_NAME")" == "$_PROJECT_HOMEPAGE" ]]; then
        ok
    else
        set_url_RPMBUILD "$_PROJECT_HOMEPAGE" "$_PROJECT_NAME"
        [[ "$(get_url_RPMBUILD "$_PROJECT_NAME")" == "$_PROJECT_HOMEPAGE" ]] && ok || ko
    fi

    echo -n "* remoteinclude.spec (source):                        "
    if [[ "$(get_source_RPMBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]]; then
        ok
    else
        set_source_RPMBUILD "$_PROJECT_SOURCE" "$_PROJECT_NAME" "$_PROJECT_VERSION"
        [[ "$(get_source_RPMBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]] && ok || ko
        echo "$(get_source_RPMBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")"
    fi

    echo -n "* remoteinclude.spec (description):                   "
    if [[ "$(get_description_RPMBUILD)" == "$_PROJECT_DESCRIPTION" ]]; then
        ok
    else
        set_description_RPMBUILD "$_PROJECT_DESCRIPTION"
        [[ "$(get_description_RPMBUILD)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
    fi
fi

if [[ -f PKGBUILD ]]; then
    echo -n "* PKGBUILD (_pkgname):                                "
    if [[ "$(get__pkgname_PKGBUILD)" == "$_PROJECT_NAME" ]]; then
        ok
    else
        set__pkgname_PKGBUILD "$_PROJECT_NAME"
        [[ "$(get__pkgname_PKGBUILD)" == "$_PROJECT_NAME" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (pkgname):                                 "
    if [[ "$(get_pkgname_PKGBUILD)" == "$_PROJECT_NAME_LOWER" ]]; then
        ok
    else
        set_pkgname_PKGBUILD "$_PROJECT_NAME_LOWER"
        [[ "$(get_pkgname_PKGBUILD)" == "$_PROJECT_NAME_LOWER" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (version):                                 "
    if [[ "$(get_version_PKGBUILD)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_PKGBUILD "$_PROJECT_VERSION"
        [[ "$(get_version_PKGBUILD)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (license):                                 "
    if [[ "$(get_license_PKGBUILD)" == "$_PROJECT_LICENSE_PKG" ]]; then
        ok
    else
        set_license_PKGBUILD "$_PROJECT_LICENSE_PKG"
        [[ "$(get_license_PKGBUILD)" == "$_PROJECT_LICENSE_PKG" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (pkgdesc):                                 "
    if [[ "$(get_pkgdesc_PKGBUILD)" == "$_PROJECT_SUMMARY" ]]; then
        ok
    else
        set_pkgdesc_PKGBUILD "$_PROJECT_SUMMARY"
        [[ "$(get_pkgdesc_PKGBUILD)" == "$_PROJECT_SUMMARY" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (url):                                     "
    if [[ "$(get_url_PKGBUILD "$_PROJECT_NAME")" == "$_PROJECT_HOMEPAGE" ]]; then
        ok
    else
        set_url_PKGBUILD "$_PROJECT_HOMEPAGE" "$_PROJECT_NAME"
        [[ "$(get_url_PKGBUILD "$_PROJECT_NAME")" == "$_PROJECT_HOMEPAGE" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (source):                                  "
    if [[ "$(get_source_PKGBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]]; then
        ok
    else
        set_source_PKGBUILD "$_PROJECT_SOURCE" "$_PROJECT_NAME" "$_PROJECT_VERSION"
        [[ "$(get_source_PKGBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (md5):                                     "
    if [[ "$(get_md5_PKGBUILD)" == "$_PROJECT_MD5" ]]; then
        ok
    else
        set_md5_PKGBUILD "$_PROJECT_MD5"
        [[ "$(get_md5_PKGBUILD)" == "$_PROJECT_MD5" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha1):                                    "
    if [[ "$(get_sha1_PKGBUILD)" == "$_PROJECT_SHA1" ]]; then
        ok
    else
        set_sha1_PKGBUILD "$_PROJECT_SHA1"
        [[ "$(get_sha1_PKGBUILD)" == "$_PROJECT_SHA1" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha224):                                  "
    if [[ "$(get_sha224_PKGBUILD)" == "$_PROJECT_SHA224" ]]; then
        ok
    else
        set_sha224_PKGBUILD "$_PROJECT_SHA224"
        [[ "$(get_sha224_PKGBUILD)" == "$_PROJECT_SHA224" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha256):                                  "
    if [[ "$(get_sha256_PKGBUILD)" == "$_PROJECT_SHA256" ]]; then
        ok
    else
        set_sha256_PKGBUILD "$_PROJECT_SHA256"
        [[ "$(get_sha256_PKGBUILD)" == "$_PROJECT_SHA256" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha384):                                  "
    if [[ "$(get_sha384_PKGBUILD)" == "$_PROJECT_SHA384" ]]; then
        ok
    else
        set_sha384_PKGBUILD "$_PROJECT_SHA384"
        [[ "$(get_sha384_PKGBUILD)" == "$_PROJECT_SHA384" ]] && ok || ko
    fi

    echo -n "* PKGBUILD (sha512):                                  "
    if [[ "$(get_sha512_PKGBUILD)" == "$_PROJECT_SHA512" ]]; then
        ok
    else
        set_sha512_PKGBUILD "$_PROJECT_SHA512"
        [[ "$(get_sha512_PKGBUILD)" == "$_PROJECT_SHA512" ]] && ok || ko
    fi
fi

if [[ -f APKBUILD ]]; then
    echo -n "* APKBUILD (_pkgname):                                "
    if [[ "$(get__pkgname_APKBUILD)" == "$_PROJECT_NAME" ]]; then
        ok
    else
        set__pkgname_APKBUILD "$_PROJECT_NAME"
        [[ "$(get__pkgname_APKBUILD)" == "$_PROJECT_NAME" ]] && ok || ko
    fi

    echo -n "* APKBUILD (pkgname):                                 "
    if [[ "$(get_pkgname_APKBUILD)" == "$_PROJECT_NAME_LOWER" ]]; then
        ok
    else
        set_pkgname_APKBUILD "$_PROJECT_NAME_LOWER"
        [[ "$(get_pkgname_APKBUILD)" == "$_PROJECT_NAME_LOWER" ]] && ok || ko
    fi

    echo -n "* APKBUILD (version):                                 "
    if [[ "$(get_version_APKBUILD)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_APKBUILD "$_PROJECT_VERSION"
        [[ "$(get_version_APKBUILD)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* APKBUILD (license):                                 "
    if [[ "$(get_license_APKBUILD)" == "$_PROJECT_LICENSE_APK" ]]; then
        ok
    else
        set_license_APKBUILD "$_PROJECT_LICENSE_APK"
        [[ "$(get_license_APKBUILD)" == "$_PROJECT_LICENSE_APK" ]] && ok || ko
    fi

    echo -n "* APKBUILD (pkgdesc):                                 "
    if [[ "$(get_pkgdesc_APKBUILD)" == "$_PROJECT_SUMMARY" ]]; then
        ok
    else
        set_pkgdesc_APKBUILD "$_PROJECT_SUMMARY"
        [[ "$(get_pkgdesc_APKBUILD)" == "$_PROJECT_SUMMARY" ]] && ok || ko
    fi

    echo -n "* APKBUILD (url):                                     "
    if [[ "$(get_url_APKBUILD "$_PROJECT_NAME")" == "$_PROJECT_HOMEPAGE" ]]; then
        ok
    else
        set_url_APKBUILD "$_PROJECT_HOMEPAGE" "$_PROJECT_NAME"
        [[ "$(get_url_APKBUILD "$_PROJECT_NAME")" == "$_PROJECT_HOMEPAGE" ]] && ok || ko
    fi

    echo -n "* APKBUILD (giturl):                                  "
    if [[ "$(get_giturl_APKBUILD "$_PROJECT_NAME")" == "$_PROJECT_VCS" ]]; then
        ok
    else
        set_giturl_APKBUILD "$_PROJECT_VCS" "$_PROJECT_NAME"
        [[ "$(get_giturl_APKBUILD "$_PROJECT_NAME")" == "$_PROJECT_VCS" ]] && ok || ko
        echo "$(get_giturl_APKBUILD "$_PROJECT_NAME")"
    fi

    echo -n "* APKBUILD (source):                                  "
    if [[ "$(get_source_APKBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]]; then
        ok
    else
        set_source_APKBUILD "$_PROJECT_SOURCE" "$_PROJECT_NAME" "$_PROJECT_VERSION"
        [[ "$(get_source_APKBUILD "$_PROJECT_NAME" "$_PROJECT_VERSION")" == "$_PROJECT_SOURCE" ]] && ok || ko
    fi

    echo -n "* APKBUILD (md5):                                     "
    if [[ "$(get_md5_APKBUILD)" == "$_PROJECT_MD5" ]]; then
        ok
    else
        set_md5_APKBUILD "$_PROJECT_MD5"
        [[ "$(get_md5_APKBUILD)" == "$_PROJECT_MD5" ]] && ok || ko
    fi

    echo -n "* APKBUILD (sha256):                                  "
    if [[ "$(get_sha256_APKBUILD)" == "$_PROJECT_SHA256" ]]; then
        ok
    else
        set_sha256_APKBUILD "$_PROJECT_SHA256"
        [[ "$(get_sha256_APKBUILD)" == "$_PROJECT_SHA256" ]] && ok || ko
    fi

    echo -n "* APKBUILD (sha512):                                  "
    if [[ "$(get_sha512_APKBUILD)" == "$_PROJECT_SHA512" ]]; then
        ok
    else
        set_sha512_APKBUILD "$_PROJECT_SHA512"
        [[ "$(get_sha512_APKBUILD)" == "$_PROJECT_SHA512" ]] && ok || ko
    fi
fi

if [[ -f CMakeLists.txt ]]; then
    echo -n "* CMakeLists.txt (PROJECT_NAME):                      "
    if [[ "$(get_name_CMAKE)" == "$_PROJECT_NAME" ]]; then
        ok
    else
        set_name_CMAKE "$_PROJECT_NAME"
        [[ "$(get_name_CMAKE)" == "$_PROJECT_NAME" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (PROJECT_VERSION):                   "
    if [[ "$(get_version_CMAKE)" == "$_PROJECT_VERSION" ]]; then
        ok
    else
        set_version_CMAKE "$_PROJECT_VERSION"
        [[ "$(get_version_CMAKE)" == "$_PROJECT_VERSION" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (PROJECT_DESCRIPTION):               "
    if [[ "$(get_description_CMAKE)" == "$_PROJECT_SUMMARY" ]]; then
        ok
    else
        set_description_CMAKE "$_PROJECT_SUMMARY"
        [[ "$(get_description_CMAKE)" == "$_PROJECT_SUMMARY" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (PROJECT_HOMEPAGE_URL):              "
    if [[ "$(get_homepage_url_CMAKE)" == "$_PROJECT_HOMEPAGE" ]]; then
        ok
    else
        set_homepage_url_CMAKE "$_PROJECT_HOMEPAGE"
        [[ "$(get_homepage_url_CMAKE)" == "$_PROJECT_HOMEPAGE" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (CPACK_PACKAGE_VENDOR):              "
    if [[ "$(get_vendor_CMAKE)" == "$_PROJECT_VENDOR_ASCII" ]]; then
        ok
    else
        set_vendor_CMAKE "$_PROJECT_VENDOR_ASCII"
        [[ "$(get_vendor_CMAKE)" == "$_PROJECT_VENDOR_ASCII" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (CPACK_PACKAGE_CONTACT):             "
    if [[ "$(get_contact_CMAKE)" == "$_AUTHOR_CONTACT" ]]; then
        ok
    else
        set_contact_CMAKE "$_AUTHOR_CONTACT"
        [[ "$(get_contact_CMAKE)" == "$_AUTHOR_CONTACT" ]] && ok || ko
    fi

    echo -n "* CMakeLists.txt (CPACK_PACKAGE_DESCRIPTION_SUMMARY): "
    if [[ "$(get_summary_CMAKE)" == "$_PROJECT_SUMMARY" ]]; then
        ok
    else
        set_summary_CMAKE "$_PROJECT_SUMMARY"
        [[ "$(get_summary_CMAKE)" == "$_PROJECT_SUMMARY" ]] && ok || ko
    fi
fi

if [[ -f .appveyor.yml ]]; then
    echo -n "* .appveyor.yml (version):                            "
    if [[ "$(get_version_APPVEYOR)" == "$_PROJECT_VERSION-{build}" ]]; then
        ok
    else
        set_version_APPVEYOR "$_PROJECT_VERSION-{build}"
        [[ "$(get_version_APPVEYOR)" == "$_PROJECT_VERSION-{build}" ]] && ok || ko
    fi
fi

function space() {
    local diff=$((3 - $(echo -n "$1" | wc -c)))
    printf "%-${diff}s" ''
}

for ext in xz apk; do
    if [[ -f "Dockerfile.$ext" ]]; then
        echo -n "* Dockerfile.$ext (AUTHOR_USER):                       "
        space "$ext"
        if [[ "$(get_author_user_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_USER" ]]; then
            ok
        else
            set_author_user_DOCKER "Dockerfile.$ext" "$_AUTHOR_USER"
            [[ "$(get_author_user_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_USER" ]] && ok || ko
        fi
    
        echo -n "* Dockerfile.$ext (AUTHOR_NAME):                       "
        space "$ext"
        if [[ "$(get_author_name_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_NAME" ]]; then
            ok
        else
            set_author_name_DOCKER "Dockerfile.$ext" "$_AUTHOR_NAME"
            [[ "$(get_author_name_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_NAME" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (AUTHOR_NAME_ASCII):                 "
        space "$ext"
        if [[ "$(get_author_name_ascii_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_NAME_ASCII" ]]; then
            ok
        else
            set_author_name_ascii_DOCKER "Dockerfile.$ext" "$_AUTHOR_NAME_ASCII"
            [[ "$(get_author_name_ascii_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_NAME_ASCII" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (AUTHOR_EMAIL):                      "
        space "$ext"
        if [[ "$(get_author_email_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_EMAIL" ]]; then
            ok
        else
            set_author_email_DOCKER "Dockerfile.$ext" "$_AUTHOR_EMAIL"
            [[ "$(get_author_email_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_EMAIL" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_NAME):                      "
        space "$ext"
        if [[ "$(get_project_name_DOCKER "Dockerfile.$ext")" == "$_PROJECT_NAME" ]]; then
            ok
        else
            set_project_name_DOCKER "Dockerfile.$ext" "$_PROJECT_NAME"
            [[ "$(get_project_name_DOCKER "Dockerfile.$ext")" == "$_PROJECT_NAME" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_DESCRIPTION):               "
        space "$ext"
        if [[ "$(get_project_description_DOCKER "Dockerfile.$ext")" == "$_PROJECT_SUMMARY" ]]; then
            ok
        else
            set_project_description_DOCKER "Dockerfile.$ext" "$_PROJECT_SUMMARY"
            [[ "$(get_project_description_DOCKER "Dockerfile.$ext")" == "$_PROJECT_SUMMARY" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_VERSION):                   "
        space "$ext"
        if [[ "$(get_project_version_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VERSION" ]]; then
            ok
        else
            set_project_version_DOCKER "Dockerfile.$ext" "$_PROJECT_VERSION"
            [[ "$(get_project_version_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VERSION" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_SHA512):                    "
        space "$ext"
        if [[ "$(get_project_sha512_DOCKER "Dockerfile.$ext")" == "$_PROJECT_SHA512" ]]; then
            ok
        else
            set_project_sha512_DOCKER "Dockerfile.$ext" "$_PROJECT_SHA512"
            [[ "$(get_project_sha512_DOCKER "Dockerfile.$ext")" == "$_PROJECT_SHA512" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (AUTHOR_CONTACT):                    "
        space "$ext"
        if [[ "$(get_author_contact_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_CONTACT" ]]; then
            ok
        else
            set_author_contact_DOCKER "Dockerfile.$ext" "$_AUTHOR_CONTACT"
            [[ "$(get_author_contact_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_CONTACT" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (AUTHOR_CONTACT_ASCII):              "
        space "$ext"
        if [[ "$(get_author_contact_ascii_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_CONTACT_ASCII" ]]; then
            ok
        else
            set_author_contact_ascii_DOCKER "Dockerfile.$ext" "$_AUTHOR_CONTACT_ASCII"
            [[ "$(get_author_contact_ascii_DOCKER "Dockerfile.$ext")" == "$_AUTHOR_CONTACT_ASCII" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_VENDOR):                    "
        space "$ext"
        if [[ "$(get_project_vendor_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VENDOR" ]]; then
            ok
        else
            set_project_vendor_DOCKER "Dockerfile.$ext" "$_PROJECT_VENDOR"
            [[ "$(get_project_vendor_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VENDOR" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_VENDOR_ASCII):              "
        space "$ext"
        if [[ "$(get_project_vendor_ascii_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VENDOR_ASCII" ]]; then
            ok
        else
            set_project_vendor_ascii_DOCKER "Dockerfile.$ext" "$_PROJECT_VENDOR_ASCII"
            [[ "$(get_project_vendor_ascii_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VENDOR_ASCII" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_HOMEPAGE):                  "
        space "$ext"
        if [[ "$(get_project_homepage_DOCKER "Dockerfile.$ext")" == "$_PROJECT_HOMEPAGE" ]]; then
            ok
        else
            set_project_homepage_DOCKER "Dockerfile.$ext" "$_PROJECT_HOMEPAGE"
            [[ "$(get_project_homepage_DOCKER "Dockerfile.$ext")" == "$_PROJECT_HOMEPAGE" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_URL):                       "
        space "$ext"
        if [[ "$(get_project_url_DOCKER "Dockerfile.$ext")" == "$_PROJECT_URL" ]]; then
            ok
        else
            set_project_url_DOCKER "Dockerfile.$ext" "$_PROJECT_URL"
            [[ "$(get_project_url_DOCKER "Dockerfile.$ext")" == "$_PROJECT_URL" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_VCS):                       "
        space "$ext"
        if [[ "$(get_project_vcs_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VCS" ]]; then
            ok
        else
            set_project_vcs_DOCKER "Dockerfile.$ext" "$_PROJECT_VCS"
            [[ "$(get_project_vcs_DOCKER "Dockerfile.$ext")" == "$_PROJECT_VCS" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (PROJECT_SOURCE):                    "
        space "$ext"
        if [[ "$(get_project_source_DOCKER "Dockerfile.$ext")" == "$_PROJECT_SOURCE" ]]; then
            ok
        else
            set_project_source_DOCKER "Dockerfile.$ext" "$_PROJECT_SOURCE"
            [[ "$(get_project_source_DOCKER "Dockerfile.$ext")" == "$_PROJECT_SOURCE" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (CMAKE_BUILD_TYPE):                  "
        space "$ext"
        if [[ "$(get_cmake_build_type_DOCKER "Dockerfile.$ext")" == "$_CMAKE_BUILD_TYPE" ]]; then
            ok
        else
            set_cmake_build_type_DOCKER "Dockerfile.$ext" "$_CMAKE_BUILD_TYPE"
            [[ "$(get_cmake_build_type_DOCKER "Dockerfile.$ext")" == "$_CMAKE_BUILD_TYPE" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_BUILD_DATE):                  "
        space "$ext"
        set_label_build_date_DOCKER "Dockerfile.$ext" "$_LABEL_BUILD_DATE"
        ok

        echo -n "* Dockerfile.$ext (LABEL_NAME):                        "
        space "$ext"
        if [[ "$(get_label_name_DOCKER "Dockerfile.$ext")" == "$_LABEL_NAME" ]]; then
            ok
        else
            set_label_name_DOCKER "Dockerfile.$ext" "$_LABEL_NAME"
            [[ "$(get_label_name_DOCKER "Dockerfile.$ext")" == "$_LABEL_NAME" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_DESCRIPTION):                 "
        space "$ext"
        if [[ "$(get_label_description_DOCKER "Dockerfile.$ext")" == "$_LABEL_DESCRIPTION" ]]; then
            ok
        else
            set_label_description_DOCKER "Dockerfile.$ext" "$_LABEL_DESCRIPTION"
            [[ "$(get_label_description_DOCKER "Dockerfile.$ext")" == "$_LABEL_DESCRIPTION" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_USAGE):                       "
        space "$ext"
        if [[ "$(get_label_usage_DOCKER "Dockerfile.$ext")" == "$_LABEL_USAGE" ]]; then
            ok
        else
            set_label_usage_DOCKER "Dockerfile.$ext" "$_LABEL_USAGE"
            [[ "$(get_label_usage_DOCKER "Dockerfile.$ext")" == "$_LABEL_USAGE" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_URL):                         "
        space "$ext"
        if [[ "$(get_label_url_DOCKER "Dockerfile.$ext")" == "$_LABEL_URL" ]]; then
            ok
        else
            set_label_url_DOCKER "Dockerfile.$ext" "$_LABEL_URL"
            [[ "$(get_label_url_DOCKER "Dockerfile.$ext")" == "$_LABEL_URL" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_VCS_URL):                     "
        space "$ext"
        if [[ "$(get_label_vcs_url_DOCKER "Dockerfile.$ext")" == "$_LABEL_VCS_URL" ]]; then
            ok
        else
            set_label_vcs_url_DOCKER "Dockerfile.$ext" "$_LABEL_VCS_URL"
            [[ "$(get_label_vcs_url_DOCKER "Dockerfile.$ext")" == "$_LABEL_VCS_URL" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_VCS_REF):                     "
        space "$ext"
        if [[ "$(get_label_vcs_ref_DOCKER "Dockerfile.$ext")" == "$_LABEL_VCS_REF" ]]; then
            ok
        else
            set_label_vcs_ref_DOCKER "Dockerfile.$ext" "$_LABEL_VCS_REF"
            [[ "$(get_label_vcs_ref_DOCKER "Dockerfile.$ext")" == "$_LABEL_VCS_REF" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_VENDOR):                      "
        space "$ext"
        if [[ "$(get_label_vendor_DOCKER "Dockerfile.$ext")" == "$_LABEL_VENDOR" ]]; then
            ok
        else
            set_label_vendor_DOCKER "Dockerfile.$ext" "$_LABEL_VENDOR"
            [[ "$(get_label_vendor_DOCKER "Dockerfile.$ext")" == "$_LABEL_VENDOR" ]] && ok || ko
        fi

        echo -n "* Dockerfile.$ext (LABEL_VERSION):                     "
        space "$ext"
        if [[ "$(get_label_version_DOCKER "Dockerfile.$ext")" == "$_LABEL_VERSION" ]]; then
            ok
        else
            set_label_version_DOCKER "Dockerfile.$ext" "$_LABEL_VERSION"
            [[ "$(get_label_version_DOCKER "Dockerfile.$ext")" == "$_LABEL_VERSION" ]] && ok || ko
        fi
    fi
done

if [[ -f .abuild/abuild.conf ]]; then
    echo -n "* abuild.conf (PACKAGER):                              "
    if [[ "$(get_packager_ABUILD)" == "$_AUTHOR_CONTACT" ]]; then
        ok
    else
        set_packager_ABUILD "$_AUTHOR_CONTACT"
        [[ "$(get_packager_ABUILD)" == "$_AUTHOR_CONTACT" ]] && ok || ko
    fi
fi
