#!/bin/bash

exit_msg ()
{
    echo "inc_tar.sh:"
    echo "Make an incremental tar backup."
    echo " -- Useful for backing to an external drive."
    echo "  requires 2 positional args and an optional 3rd positional arg:"
    echo '    $1="dir to backup" path to a dir'
    echo '    $2="destination dir" path to a dir *with* the trailing slash'
    echo '    [$3="archive name"] a sane string for use in a file name'
    echo
}

# if no params -> help
if [ -z "$1" ]; then
    echo "exiting without running anything"
    exit_msg
    exit 0
fi

tobak="$1"
dest="$2"

if [ -z "$3" ]; then
    name="$(basename "$tobak")"
else
    name=$3
fi

if ! [ -d "$tobak" ]; then
    echo "First argument must be a path to the source *directory*."
    exit 1
fi

if ! [ -d "$dest" ]; then
    echo "Second argument must be a path to the destination *directory*."
    exit 1
fi

fname=$name-"$(date +%Y-%m-%d)".tar.bz2

echo "Archiving $dir/$tobak"
echo "to $fname"
echo "in $dest"

tar --create --bzip2 --listed-incremental=$name.snar --file=$dest$fname $tobak

exit 0

