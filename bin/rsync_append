#!/bin/bash
THISDIR="$(cd `dirname "$0"` && pwd)"
ROOTDIR="$( dirname "$THISDIR" )"
LIBDIR="$ROOTDIR/lib"
source "$LIBDIR/utils.sh"

if [ -z $1 ]; then
    echo "Mirror files from a src to a destination without deleting"
    echo
    echo "  <src> <dest> <logfile> [<excludefile>]"
    echo
    echo "! <src> and <dest> directory names to *not* need to have a trailing /"
    exit 0
fi

main () {
    local src="$1"
    local dest="$2"
    local logfile="$3"
    local excludefile="$4"

    local options="\
        --recursive \
        --links \
        --perms \
        --times \
        --owner \
        --progress \
        --human-readable \
        "
    if [ -z "$logfile" ]; then
        fail "$0: logfile is a required argument"
    fi

    options="$options --log-file=$logfile"

    if [ -f "$excludefile" ]; then
        options="$options --exclude-from=$excludefile"
    fi

    rsync $options "$src/" "$dest/" || fail "$0: rsync failed"
}

main "$@"
