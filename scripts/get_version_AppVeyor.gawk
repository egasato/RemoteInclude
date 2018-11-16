/^version[ \t]*:[ \t]*("(.*)"|''(.*)'')$/ {
    contains = match($0, /^version[ \t]*:[ \t]*("(.*)"|''(.*)'')$/, arr)
    if (contains > 0) {
        print arr[2]
        exit
    }
}
