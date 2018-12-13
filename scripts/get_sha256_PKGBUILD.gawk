/^sha256sums=.*$/ {
    contains = match($0, /^sha256sums=\("([^ ]*)"\)$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
