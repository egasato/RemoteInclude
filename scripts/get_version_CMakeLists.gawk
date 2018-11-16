/^[ \t]*project\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^.*VERSION[ \t]+([0-9]+(\.[0-9]+)+).*$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
