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

IP=$1
USER=$2
SYNC_DIR=$3

# Remove the previous log
if [ -f $SYNC_DIR/sync.log ]; then
    echo 'removing previous log file...'
    rm $SYNC_DIR/sync.log
fi

# Check for the sync.list
if ! [ -f $SYNC_DIR/sync.list ]; then
    echo 'could not find '$SYNC_DIR/sync.list
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
--exclude-from=$SYNC_DIR/sync.list \
--log-file=$SYNC_DIR/sync.log \
$USER@192.168.1.$IP:~/ ~/

exit $?
