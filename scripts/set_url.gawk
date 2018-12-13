/^url=.*$/ {
    contains = match($0, /^(url=").*(".*)$/, arr)
    if (contains > 0) {
        gsub(project_name, "${pkgname}", project_url)
        print arr[1] project_url arr[2]
        next
    }
}
{
    print
}
