/^[ \t]*project\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^.*HOMEPAGE_URL[ \t]+([^ \t]+).*$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
/^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^.*PROJECT_HOMEPAGE_URL[ \t]+([^ \t\)]*).*$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
