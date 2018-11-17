/^url=.*$/ {
    contains = match($0, /^url="(.*)"$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
