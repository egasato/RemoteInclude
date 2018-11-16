/^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^(.*CPACK_PACKAGE_DESCRIPTION_SUMMARY[ \t]+")(.*)(".*)$/, arr)
    if (contains > 0) {
        print arr[2]
        exit
    }
}
