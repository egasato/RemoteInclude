/-apk/ {
    contains = match($0, /^(.*[ \t]+-t[ \t]+).*(-apk([ \t]+.*)?)$/, arr)
    if (contains > 0) {
        print arr[1] tolower(project_name) arr[2]
        next
    }
    contains = match($0, /^([ \t]*).*(-apk.*)$/, arr)
    if (contains > 0) {
        print arr[1] tolower(project_name) arr[2]
        next
    }
}
{
    print
}
