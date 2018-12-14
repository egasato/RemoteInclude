/^_pkgname=.*$/ {
    contains = match($0, /^(_pkgname=").*(".*)$/, arr)
    if (contains > 0) {
        print arr[1] project_name arr[2]
        next
    }
}
/^pkgname=.*$/ {
    contains = match($0, /^(pkgname=").*(".*)$/, arr)
    if (contains > 0) {
        print arr[1] project_name_lower arr[2]
        next
    }
}
{
    print
}
