/^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^(.*CPACK_PACKAGE_CONTACT[ \t]+")(.*)(".*)$/, arr)
    if (contains > 0) {
        print arr[1] author_contact arr[3]
        next
    }
}
{
    print
}