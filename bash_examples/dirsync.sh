#!/bin/bash

## This script demonstrates how to use rsync to copy an entire directory
## to a remote (or local) location.

main () {
    local cmd="$1"
    local src="$( pwd )"
    local remote="$2"
    local dowrite="$3"

    opts="\
    --recursive \
    --update \
    --links \
    --perms \
    --times \
    --owner \
    --group \
    --progress \
    --omit-dir-times \
    --checksum \
    --human-readable \
    "

    if [ "$dowrite" != "-w" ]; then
        opts="--dry-run $opts"
    fi

    case $cmd in
        'push')
            rsync $opts "$src/" "$remote" || fail "$0: rsync failed"
            ;;
        'push-delete')
            rsync --delete $opts "$src/" "$remote" || fail "$0: rsync failed"
            ;;
        * )
            echo "Possible commands:"
            echo "  push <target-dir> [-w]  # <target-dir> should end in a '/'"
            echo "  push-delete <target-dir> [-w]  # <target-dir> should end in a '/'"
            echo ""
            echo "Warning! sync works in the dir given by pwd and "
            echo "defaults to --dry-run. To actually do the sync operation,"
            echo "you need to pass the -w option after the command"
            ;;
    esac
}

main "$@"
