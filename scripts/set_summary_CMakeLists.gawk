/^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^(.*CPACK_PACKAGE_DESCRIPTION_SUMMARY[ \t]+").*(".*)$/, arr)
    if (contains > 0) {
        print arr[1] project_description arr[2]
        next
    }
}
{
    print
}
