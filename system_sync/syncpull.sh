#!/bin/bash
# Sync up machines by calling this script.
# -r --recursive
# -l --links copy simlinks as simlinks (don't resolve them)
# -p --perms preserve permissions
# -t --times preserve modification times
# -g --group preserve group
# -o --owner preserve owner
# -u --update skip files that are newer on the receiver
# --del reciever deletes extraneous files during transfer
# --commpress compress data
# --exclude-from=FILE read exclude patterns from file
# --human-readable
# --progress
# --log-file=FILE

# Remove the previous log
if [ -f $2/sync.log ]; then
    echo 'removing previous log file...'
    rm $2/sync.log
fi

# Check for the sync.list
if ! [ -f $2/sync.list ]; then
    echo 'could not find '$2/sync.list
    echo 'try running the update script first'
    exit 1
fi

rsync \
--recursive \
--links \
--perms \
--times \
--group \
--owner \
--del \
--compress \
--progress \
--human-readable \
--exclude-from=$sync/sync.list \
--log-file=$sync/sync.log \
kixx@192.168.1.$1:~/ ~/

exit $?
