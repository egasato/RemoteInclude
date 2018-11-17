/PACKAGER=.*/ {
    contains = match($0, /^(PACKAGER=").*(".*)$/, arr)
    if (contains > 0) {
        print arr[1] author_contact arr[2]
        next
    }
}
{
    print
}
