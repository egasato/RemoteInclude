/^pkgver=.*$/ {
    contains = match($0, /^(pkgver=).*$/, arr)
    if (contains > 0) {
        print arr[1] project_version
        next
    }
}
{
    print
}
