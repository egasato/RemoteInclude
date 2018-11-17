/^source=.*$/ {
    contains = match($0, /^source="(.+::)?(.*)"$/, arr)
    if (contains > 0) {
        print arr[2]
        exit
    }
}
