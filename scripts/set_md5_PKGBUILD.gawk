/^md5sums=.*$/ {
    contains = match($0, /^(md5sums=\(").*("\).*)$/, arr)
    if (contains > 0) {
        print arr[1] project_md5 arr[2]
        next
    }
}
{
    print
}
