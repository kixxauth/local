#!/bin/bash
nosync=$HOME/nosync
sync=$nosync/sync

# Create the sync dir if it does not exist
if [ -d $sync ]; then
    echo $sync' dir already created'
else
    echo 'creating '$sync' dir'
    mkdir $sync
fi

# Create the bin dir if it does not exist
if [ -d ~/local/bin ]; then
    echo '~/local/bin dir already created'
else
    echo 'creating ~/local/bin dir'
    mkdir ~/local/bin
fi

# update the 'local' git repo
echo 'pulling local git repo from Github'
cd ~/projects/github/local
git pull origin master

# update the rsync exclude list
echo 'updating sync.list'
cp system_sync/sync.list $sync/sync.list

# update the rsync script
echo 'updating syncpull'
cp system_sync/syncpull.sh ~/local/bin/syncpull
chmod 764 ~/local/bin/syncpull

# update this script
echo 'updating update'
cp update.sh ~/local/bin/update
chmod 764 ~/local/bin/update
