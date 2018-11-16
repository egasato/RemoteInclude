/^[ \t]*project\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^(.*DESCRIPTION[ \t]+")(.*)(".*)$/, arr)
    if (contains > 0) {
        print arr[1] project_description arr[3]
        next
    }
}
/^[ \t]*set\(/,/[ \t]*[^\)]*\)/ {
    contains = match($0, /^(.*PROJECT_DESCRIPTION[ \t]+")(.*)(".*)$/, arr)
    if (contains > 0) {
        print arr[1] project_description arr[3]
        next
    }
}
{
    print
}
