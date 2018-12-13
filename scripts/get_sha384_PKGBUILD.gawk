/^sha384sums=.*$/ {
    contains = match($0, /^sha384sums=\("([^ ]*)"\)$/, arr)
    if (contains > 0) {
        print arr[1]
        exit
    }
}
