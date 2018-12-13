/^sha224sums=.*$/ {
    contains = match($0, /^(sha224sums=\(").*("\).*)$/, arr)
    if (contains > 0) {
        print arr[1] project_sha224 arr[2]
        next
    }
}
{
    print
}
