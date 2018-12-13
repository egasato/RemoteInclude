/^pkgdesc=.*$/ {
    contains = match($0, /^pkgdesc="(.*)"$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
