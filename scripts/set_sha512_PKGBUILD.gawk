/^sha512sums=.*$/ {
    contains = match($0, /^(sha512sums=\(").*("\).*)$/, arr)
    if (contains > 0) {
        print arr[1] project_sha512 arr[2]
        next
    }
}
{
    print
}
