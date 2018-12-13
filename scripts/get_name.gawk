/^pkgname=.*$/ {
    contains = match($0, /^pkgname="(.*)"$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
