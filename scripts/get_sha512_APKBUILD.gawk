/^sha512sums=.*$/ {
    contains = match($0, /^sha512sums="([^ ]*) ?(.*)"$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
