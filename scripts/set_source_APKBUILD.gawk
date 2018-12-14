/^source=.*$/ {
    contains = match($0, /^(source=").*(".*)$/, arr)
    if (contains > 0) {
        gsub(project_name, "${_pkgname}",   project_source)
        gsub(project_version, "${pkgver}",  project_source)
        print arr[1] "${_pkgname}-${pkgver}.tar.gz::" project_source arr[2]
        next
    }
}
{
    print
}
