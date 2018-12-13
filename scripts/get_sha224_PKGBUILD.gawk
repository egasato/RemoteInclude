/^sha224sums=.*$/ {
    contains = match($0, /^sha224sums=\("([^ ]*)"\)$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
