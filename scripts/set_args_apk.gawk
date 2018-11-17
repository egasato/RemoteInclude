/^ARG[ \t]+AUTHOR_.+=.*$/ {
    contains = match($0, /^(ARG[ \t]+AUTHOR_(.+)=").*(".*)$/, arr)
    if (contains > 0) {
        if (arr[2] == "USER") {
            print arr[1] author_user arr[3]
        } else if (arr[2] == "NAME") {
            print arr[1] author_name arr[3]
        } else if (arr[2] == "NAME_ASCII") {
            print arr[1] author_name_ascii arr[3]
        } else if (arr[2] == "EMAIL") {
            print arr[1] author_email arr[3]
        } else if (arr[2] == "CONTACT") {
            print arr[1] author_contact arr[3]
        } else if (arr[2] == "CONTACT_ASCII") {
            print arr[1] author_contact_ascii arr[3]
        }
        next
    }
}
/^ARG[ \t]+PROJECT_.+=.*$/ {
    contains = match($0, /^(ARG[ \t]+PROJECT_(.+)=").*(".*)$/, arr)
    if (contains > 0) {
        if (arr[2] == "NAME") {
            print arr[1] project_name arr[3]
        } else if (arr[2] == "DESCRIPTION") {
            print arr[1] project_description arr[3]
        } else if (arr[2] == "VERSION") {
            print arr[1] project_version arr[3]
        } else if (arr[2] == "SHA512") {
            print arr[1] project_sha512 arr[3]
        } else if (arr[2] == "VENDOR") {
            print arr[1] project_vendor arr[3]
        } else if (arr[2] == "VENDOR_ASCII") {
            print arr[1] project_vendor_ascii arr[3]
        } else if (arr[2] == "HOMEPAGE") {
            print arr[1] project_homepage arr[3]
        } else if (arr[2] == "URL") {
            print arr[1] project_url arr[3]
        } else if (arr[2] == "VCS") {
            print arr[1] project_vcs arr[3]
        } else if (arr[2] == "SOURCE") {
            print arr[1] project_source arr[3]
        }
        next
    }
}
/^ARG[ \t]+LABEL_.+=.*$/ {
    contains = match($0, /^(ARG[ \t]+LABEL_(.+)=").*(".*)$/, arr)
    if (contains > 0) {
        if (arr[2] == "BUILD_DATE") {
            print arr[1] label_build_date arr[3]
        } else if (arr[2] == "NAME") {
            print arr[1] label_name arr[3]
        } else if (arr[2] == "DESCRIPTION") {
            print arr[1] label_description arr[3]
        } else if (arr[2] == "USAGE") {
            print arr[1] label_usage arr[3]
        } else if (arr[2] == "URL") {
            print arr[1] label_url arr[3]
        } else if (arr[2] == "VCS_URL") {
            print arr[1] label_vcs_url arr[3]
        } else if (arr[2] == "VCS_REF") {
            print arr[1] label_vcs_ref arr[3]
        } else if (arr[2] == "VENDOR") {
            print arr[1] label_vendor arr[3]
        } else if (arr[2] == "VERSION") {
            print arr[1] label_version arr[3]
        }
        next
    }
}
{
    print
}
