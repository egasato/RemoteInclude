/^version[ \t]*:[ \t]*(\".*\"|'.*').*$/ {
    contains = match($0, /^(version[ \t]*:[ \t]*)((")(.*)"|(')(.*)')(.*)$/, arr)
    if (contains > 0) {
        print arr[1] arr[3] project_version "-{build}" arr[3] arr[5]
        next
    }
}
{
    print
}
