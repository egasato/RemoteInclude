/^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^(.*CPACK_PACKAGE_VENDOR[ \t]+")(.*)(".*)$/, arr)
    if (contains > 0) {
        print arr[1] project_vendor arr[3]
        next
    }
}
{
    print
}
