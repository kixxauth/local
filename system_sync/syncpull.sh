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
NOSYNC=$HOME/nosync
SYNC=$NOSYNC/sync

# Create the sync dir if it does not exist
if [ -d $SYNC ]; then
    echo $SYNC' dir already created'
else
    echo 'creating '$SYNC' dir'
    mkdir $SYNC
fi

# Download the exclude list if we don't have it already.
if ! [ -f $SYNC/sync.list ]; then
    echo 'getting sync.list from GitHub'
    wget http://github.com/kixxauth/scripts/raw/master/sync.list $SYNC/sync.list
    if ! [ -f $SYNC/sync.list ]; then
        echo 'unable to download sync.list from GitHub'
        # We can't go on.
        exit
    fi
else
    echo 'sync.list already downloaded'
fi

rsync \
--recursive \
--links \
--perms \
--times \
--group \
--owner \
--update \
--del \
--compress \
--progress \
--human-readable \
--exclude-from=$SYNC/sync.list \
--log-file=$SYNC/sync.log \
kixx@192.168.1.$1:~/ ~/
