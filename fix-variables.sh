#!/usr/bin/env bash

# Load all the project properties
source project.properties.sh

# Prints a green OK
function ok() {
    echo -e "\e[32mOK\e[39m"
}

# Prints a red KO
function ko() {
    echo -e "\e[41mKO\e[49m"
}

## CMakeLists functions

# Returns the version number inside the CMakeLists file
function version_CMakeLists() {
    local script='
        /^[ \t]*project\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^.*VERSION[ \t]+([0-9]+(\.[0-9]+)+).*$/, arr)
            if (contains > 0) {
                print arr[1]
            }
        }
    '
    gawk "$script" CMakeLists.txt
}

# Updates the version number inside the CMakeLists file
function update_version_CMakeLists() {
    local script="
        /^[ \\t]*project\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*VERSION[ \\t]+)[0-9]+(\\.[0-9]+)+(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_VERSION\" arr[4]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}

# Returns the project description inside the CMakeLists file
function description_CMakeLists() {
    local script='
        /^[ \t]*project\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^.*DESCRIPTION[ \t]+"(.*)".*$/, arr)
            if (contains > 0) {
                print arr[1]
                exit
            }
        }
        /^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^.*PROJECT_DESCRIPTION[ \t]+"(.*)".*$/, arr)
            if (contains > 0) {
                print arr[1]
                exit
            }
        }
    '
    gawk "$script" CMakeLists.txt
}

# Updates the project description inside the CMakeLists file
function update_description_CMakeLists() {
    local script="
        /^[ \\t]*project\\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*DESCRIPTION[ \\t]+\")(.*)(\".*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_DESCRIPTION\" arr[3]
                next
            }
        }
        /^[ \\t]*set\\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*PROJECT_DESCRIPTION[ \\t]+\")(.*)(\".*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_DESCRIPTION\" arr[3]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}

# Returns the homepage inside the CMakeLists file
function homepage_CMakeLists() {
    local script='
        /^[ \t]*project\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^.*HOMEPAGE_URL[ \t]+([^ \t]+).*$/, arr)
            if (contains > 0) {
                print arr[1]
                exit
            }
        }
        /^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^.*PROJECT_HOMEPAGE_URL[ \t]+([^ \t\)]*).*$/, arr)
            if (contains > 0) {
                print arr[1]
                exit
            }
        }
    '
    gawk "$script" CMakeLists.txt
}

# Updates the homepage inside the CMakeLists file
function update_homepage_CMakeLists() {
    local script="
        /^[ \\t]*project\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*HOMEPAGE_URL[ \\t]+)[^ \\t\\)]+(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_URL\" arr[2]
                next
            }
        }
        /^[ \\t]*set\\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*PROJECT_HOMEPAGE_URL[ \\t]+)[^ \\t\\)]+(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_URL\" arr[2]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}

# Returns the CPack vendor name inside the CMakeLists file
function vendor_CMakeLists() {
    local script='
        /^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^(.*CPACK_PACKAGE_VENDOR[ \t]+")(.*)(".*)$/, arr)
            if (contains > 0) {
                print arr[2]
                exit
            }
        }
    '
    gawk "$script" CMakeLists.txt
}

# Updates the CPack vendor name inside the CMakeLists file
function update_vendor_CMakeLists() {
    local script="
        /^[ \\t]*set\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*CPACK_PACKAGE_VENDOR[ \\t]+\")(.*)(\".*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_VENDOR_ASCII\" arr[3]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}

# Returns the CPack contact inside the CMakeLists file
function contact_CMakeLists() {
    local script='
        /^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^(.*CPACK_PACKAGE_CONTACT[ \t]+")(.*)(".*)$/, arr)
            if (contains > 0) {
                print arr[2]
                exit
            }
        }
    '
    gawk "$script" CMakeLists.txt
}

# Updates the CPack contact inside the CMakeLists file
function update_contact_CMakeLists() {
    local script="
        /^[ \\t]*set\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*CPACK_PACKAGE_CONTACT[ \\t]+\")(.*)(\".*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_CONTACT\" arr[3]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}

# Returns the CPack summary inside the CMakeLists file
function summary_CMakeLists() {
    local script='
        /^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
            contains = match($0, /^(.*CPACK_PACKAGE_DESCRIPTION_SUMMARY[ \t]+")(.*)(".*)$/, arr)
            if (contains > 0) {
                print arr[2]
                exit
            }
        }
    '
    gawk "$script" CMakeLists.txt
}

# Updates the CPack summary inside the CMakeLists file
function update_summary_CMakeLists() {
    local script="
        /^[ \\t]*set\(/,/[ \\t]*[^\\)]*\\)/ {
            contains = match(\$0, /^(.*CPACK_PACKAGE_DESCRIPTION_SUMMARY[ \\t]+\")(.*)(\".*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_DESCRIPTION\" arr[3]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" CMakeLists.txt > CMakeLists.txt.tmp
    mv CMakeLists.txt.tmp CMakeLists.txt
}

# Returns the version number inside the AppVeyor file
function version_AppVeyor() {
    local script='
        /^version[ \t]*:[ \t]*("(.*)"|''(.*)'')$/ {
            contains = match($0, /^version[ \t]*:[ \t]*("(.*)"|''(.*)'')$/, arr)
            if (contains > 0) {
                print arr[2]
                exit
            }
        }
    '
    gawk "$script" .appveyor.yml
}

# Updates the version number inside the AppVeyor file
function update_version_AppVeyor() {
    local script="
        /^version[ \\t]*:[ \\t]*(\".*\"|'.*').*$/ {
            contains = match(\$0, /^(version[ \\t]*:[ \\t]*)((\")(.*)\"|(')(.*)')(.*)$/, arr)
            if (contains > 0) {
                print arr[1] arr[3] \"$_PROJECT_VERSION-{build}\" arr[3] arr[5]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" .appveyor.yml > .appveyor.yml.tmp
    mv .appveyor.yml.tmp .appveyor.yml
}

# Updates the volume paths inside the docker-apk.cmd script
function update_volumes_Docker_APK_cmd() {
    local script="
        /dst=\\/home\\/[^\\/,]+\\/[^\\.][^\\/]*/ {
            contains = match(\$0, /^(.*,dst=\\/home\\/)[^\\/,]+\\/[^\\.,]{1,2}[^\\/,]*(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER/$_PROJECT_NAME\" arr[2]
                next
            }
        }
        /dst=\\/home\\/[^\\/,]+\\/\\.[^\\/]*/ {
            contains = match(\$0, /^(.*,dst=\\/home\\/)[^\\/,]+(\\/\\.[^\\/,]*.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER\" arr[2]
                next
            }
        }
        /dst=\\/home\\/[^\\/]+/ {
            contains = match(\$0, /^(.*,dst=\\/home\\/)[^\\/,]+(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER\" arr[2]
                next
            }
        }
        /-apk/ {
            contains = match(\$0, /^(.*[ \\t]+-t[ \\t]+).*(-apk([ \\t]+.*)?)$/, arr)
            if (contains > 0) {
                print arr[1] tolower(\"$_PROJECT_NAME\") arr[2]
                next
            }
            contains = match(\$0, /^([ \\t]*).*(-apk\\^.*)$/, arr)
            if (contains > 0) {
                print arr[1] tolower(\"$_PROJECT_NAME\") arr[2]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" docker-apk.cmd > docker-apk.cmd.tmp
    mv docker-apk.cmd.tmp docker-apk.cmd
}

# Updates the volume paths inside the docker-apk.sh script
function update_volumes_Docker_APK_sh() {
    local script="
        /dst=\\/home\\/[^\\/,]+\\/[^\\.][^\\/]*/ {
            contains = match(\$0, /^(.*,dst=\\/home\\/)[^\\/,]+\\/[^\\.,]{1,2}[^\\/,]*(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER/$_PROJECT_NAME\" arr[2]
                next
            }
        }
        /dst=\\/home\\/[^\\/,]+\\/\\.[^\\/]*/ {
            contains = match(\$0, /^(.*,dst=\\/home\\/)[^\\/,]+(\\/\\.[^\\/,]*.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER\" arr[2]
                next
            }
        }
        /dst=\\/home\\/[^\\/]+/ {
            contains = match(\$0, /^(.*,dst=\\/home\\/)[^\\/,]+(.*)$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER\" arr[2]
                next
            }
        }
        /-apk/ {
            contains = match(\$0, /^(.*[ \\t]+-t[ \\t]+).*(-apk([ \\t]+.*)?)$/, arr)
            if (contains > 0) {
                print arr[1] tolower(\"$_PROJECT_NAME\") arr[2]
                next
            }
            contains = match(\$0, /^([ \\t]*).*(-apk.*)$/, arr)
            if (contains > 0) {
                print arr[1] tolower(\"$_PROJECT_NAME\") arr[2]
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" docker-apk.sh > docker-apk.sh.tmp
    mv docker-apk.sh.tmp docker-apk.sh
}

# Updates the packager inside the abuild.conf file
function update_packager_apk() {
    local script="
        /PACKAGER=.*/ {
            contains = match(\$0, /^PACKAGER=(.*)$/, arr)
            if (contains > 0) {
                print \"PACKAGER=\\\"$_AUTHOR_CONTACT\\\"\"
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" .abuild/abuild.conf > .abuild/abuild.conf.tmp
    mv .abuild/abuild.conf.tmp .abuild/abuild.conf
}

# Updates the APKBUILD spec file
function update_APKBUILD() {
    local script="
        /^_my_name=.*$/ {
            contains = match(\$0, /^(_my_name=).*$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_NAME\"
                next
            }
        }
        /^_my_group=.*$/ {
            contains = match(\$0, /^(_my_group=).*$/, arr)
            if (contains > 0) {
                print arr[1] \"$_AUTHOR_USER\"
                next
            }
        }
        /^pkgver=.*$/ {
            contains = match(\$0, /^(pkgver=).*$/, arr)
            if (contains > 0) {
                print arr[1] \"$_PROJECT_VERSION\"
                next
            }
        }
        /^pkgdesc=.*$/ {
            contains = match(\$0, /^(pkgdesc=).*$/, arr)
            if (contains > 0) {
                print arr[1] \"\\\"$_PROJECT_DESCRIPTION\\\"\"
                next
            }
        }
        /^url=.*$/ {
            contains = match(\$0, /^(url=).*$/, arr)
            if (contains > 0) {
                url = \"\\\"$_PROJECT_VCS\\\"\"
                sub(\"$_AUTHOR_USER\", \"\${_my_group}\", url)
                sub(\"$_PROJECT_NAME\", \"\${_my_name}\", url)
                print arr[1] url
                next
            }
        }
        /^source=.*$/ {
            contains = match(\$0, /^(source=).*$/, arr)
            if (contains > 0) {
                url = \"\\\"\${pkgname}.tar.gz::$_PROJECT_SOURCE\\\"\"
                sub(\"$_AUTHOR_USER\", \"\${_my_group}\", url)
                gsub(\"$_PROJECT_NAME\", \"\${_my_name}\", url)
                sub(\"$_PROJECT_VERSION\", \"\${pkgver}\", url)
                print arr[1] url
                next
            }
        }
        /^sha512sums=.*$/ {
            contains = match(\$0, /^(sha512sums=).*$/, arr)
            if (contains > 0) {
                print arr[1] \"\\\"$_PROJECT_SHA512 $_PROJECT_NAME.tar.gz\\\"\"
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" APKBUILD > APKBUILD.tmp
    mv APKBUILD.tmp APKBUILD
}

# Updates the Dockerfile used for APK packaging
function update_APK() {
    local script="
        /^ARG[ \\t]+AUTHOR_.+=.*$/ {
            contains = match(\$0, /^(ARG[ \\t]+AUTHOR_(.+)=).*$/, arr)
            if (contains > 0) {
                if (arr[2] == \"USER\") {
                    print arr[1] \"\\\"$_AUTHOR_USER\\\"\"
                } else if (arr[2] == \"NAME\") {
                    print arr[1] \"\\\"$_AUTHOR_NAME\\\"\"
                } else if (arr[2] == \"NAME_ASCII\") {
                    print arr[1] \"\\\"$_AUTHOR_NAME_ASCII\\\"\"
                } else if (arr[2] == \"EMAIL\") {
                    print arr[1] \"\\\"$_AUTHOR_EMAIL\\\"\"
                } else if (arr[2] == \"CONTACT\") {
                    print arr[1] \"\\\"$_AUTHOR_CONTACT\\\"\"
                } else if (arr[2] == \"CONTACT_ASCII\") {
                    print arr[1] \"\\\"$_AUTHOR_CONTACT_ASCII\\\"\"
                }
                next
            }
        }
        /^ARG[ \\t]+PROJECT_.+=.*$/ {
            contains = match(\$0, /^(ARG[ \\t]+PROJECT_(.+)=).*$/, arr)
            if (contains > 0) {
                if (arr[2] == \"NAME\") {
                    print arr[1] \"\\\"$_PROJECT_NAME\\\"\"
                } else if (arr[2] == \"DESCRIPTION\") {
                    print arr[1] \"\\\"$_PROJECT_DESCRIPTION\\\"\"
                } else if (arr[2] == \"VERSION\") {
                    print arr[1] \"\\\"$_PROJECT_VERSION\\\"\"
                } else if (arr[2] == \"SHA512\") {
                    print arr[1] \"\\\"$_PROJECT_SHA512\\\"\"
                } else if (arr[2] == \"VENDOR\") {
                    print arr[1] \"\\\"$_PROJECT_VENDOR\\\"\"
                } else if (arr[2] == \"VENDOR_ASCII\") {
                    print arr[1] \"\\\"$_PROJECT_VENDOR_ASCII\\\"\"
                } else if (arr[2] == \"HOMEPAGE\") {
                    print arr[1] \"\\\"$_PROJECT_HOMEPAGE\\\"\"
                } else if (arr[2] == \"URL\") {
                    print arr[1] \"\\\"$_PROJECT_URL\\\"\"
                } else if (arr[2] == \"VCS\") {
                    print arr[1] \"\\\"$_PROJECT_VCS\\\"\"
                } else if (arr[2] == \"SOURCE\") {
                    print arr[1] \"\\\"$_PROJECT_SOURCE\\\"\"
                }
                next
            }
        }
        /^ARG[ \\t]+LABEL_.+=.*$/ {
            contains = match(\$0, /^(ARG[ \\t]+LABEL_(.+)=).*$/, arr)
            if (contains > 0) {
                if (arr[2] == \"BUILD_DATE\") {
                    print arr[1] \"\\\"$_LABEL_BUILD_DATE\\\"\"
                } else if (arr[2] == \"NAME\") {
                    print arr[1] \"\\\"$_LABEL_NAME\\\"\"
                } else if (arr[2] == \"DESCRIPTION\") {
                    print arr[1] \"\\\"$_LABEL_DESCRIPTION\\\"\"
                } else if (arr[2] == \"USAGE\") {
                    print arr[1] \"\\\"$_LABEL_USAGE\\\"\"
                } else if (arr[2] == \"URL\") {
                    print arr[1] \"\\\"$_LABEL_URL\\\"\"
                } else if (arr[2] == \"VCS_URL\") {
                    print arr[1] \"\\\"$_LABEL_VCS_URL\\\"\"
                } else if (arr[2] == \"VCS_REF\") {
                    print arr[1] \"\\\"$_LABEL_VCS_REF\\\"\"
                } else if (arr[2] == \"VENDOR\") {
                    print arr[1] \"\\\"$_LABEL_VENDOR\\\"\"
                } else if (arr[2] == \"VERSION\") {
                    print arr[1] \"\\\"$_LABEL_VERSION\\\"\"
                }
                next
            }
        }
        {
            print
        }
    "
    gawk "$script" Dockerfile.apk > Dockerfile.apk.tmp
    mv Dockerfile.apk.tmp Dockerfile.apk
}

## Logic

# Update the version number
echo "Updating files":

echo -n "* CMakeLists.txt (version number): "
if [[ "$(version_CMakeLists)" == "$_PROJECT_VERSION" ]]; then
    ok
else
    update_version_CMakeLists
    [[ "$(version_CMakeLists)" == "$_PROJECT_VERSION" ]] && ok || ko
fi

echo -n "* CMakeLists.txt (description):    "
if [[ "$(description_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]]; then
    ok
else
    update_description_CMakeLists
    [[ "$(description_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
fi

echo -n "* CMakeLists.txt (homepage):       "
if [[ "$(homepage_CMakeLists)" == "$_PROJECT_URL" ]]; then
    ok
else
    update_homepage_CMakeLists
    [[ "$(homepage_CMakeLists)" == "$_PROJECT_URL" ]] && ok || ko
fi

echo -n "* CMakeLists.txt (vendor):         "
if [[ "$(vendor_CMakeLists)" == "$_PROJECT_VENDOR_ASCII" ]]; then
    ok
else
    update_vendor_CMakeLists
    [[ "$(vendor_CMakeLists)" == "$_PROJECT_VENDOR_ASCII" ]] && ok || ko
fi

echo -n "* CMakeLists.txt (contact):        "
if [[ "$(contact_CMakeLists)" == "$_AUTHOR_CONTACT" ]]; then
    ok
else
    update_contact_CMakeLists
    [[ "$(contact_CMakeLists)" == "$_AUTHOR_CONTACT" ]] && ok || ko
fi

echo -n "* CMakeLists.txt (summary):        "
if [[ "$(summary_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]]; then
    ok
else
    update_summary_CMakeLists
    [[ "$(summary_CMakeLists)" == "$_PROJECT_DESCRIPTION" ]] && ok || ko
fi

echo -n "* .appveyor.yml (version):         "
if [[ "$(version_AppVeyor)" == "$_PROJECT_VERSION-{build}" ]]; then
    ok
else
    update_version_AppVeyor
    [[ "$(version_AppVeyor)" == "$_PROJECT_VERSION-{build}" ]] && ok || ko
fi

echo -n "* docker-apk.cmd (volumes):        "
update_volumes_Docker_APK_cmd
ok

echo -n "* docker-apk.sh (volumes):         "
update_volumes_Docker_APK_sh
ok

echo -n "* abuild.conf (packager):          "
update_packager_apk
ok

echo -n "* APKBUILD (variables):            "
update_APKBUILD
ok

echo -n "* Dockerfile.apk (variables):      "
update_APK
ok
