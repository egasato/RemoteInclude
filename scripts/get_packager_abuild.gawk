/^PACKAGER=.*$/ {
    contains = match($0, /^PACKAGER="(.*)"$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
