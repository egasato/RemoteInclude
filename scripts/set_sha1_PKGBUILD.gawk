/^sha1sums=.*$/ {
    contains = match($0, /^(sha1sums=\(").*("\).*)$/, arr)
    if (contains > 0) {
        print arr[1] project_sha1 arr[2]
        next
    }
}
{
    print
}
