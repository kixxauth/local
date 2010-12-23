#!/bin/bash

# Git repos
PROJECTS_DIR=$HOME/projects
GITHUB_DIR=$PROJECTS_DIR/github

GITS="\
$GITHUB_DIR/local\
"

# For all items that are *not* to be synced between machines.
NOSYNC_DIR=$HOME/nosync

# For distro specific setup scripts and configs.
SETUP_DIR=$NOSYNC_DIR/setup

# For synchronozation scripts and logs.
SYNC_DIR=$NOSYNC_DIR/sync

# The default backup dir.
BAK_DIR=$NOSYNC_DIR/bak

# For local programs in the home dir.
LOCAL_DIR=$HOME/local
BIN_DIR=$LOCAL_DIR/bin
SBIN_DIR=$LOCAL_DIR/sbin

# Create essential directories.
DIRECTORIES="\
$LOCAL_DIR \
$BIN_DIR \
$SBIN_DIR \
$NOSYNC_DIR \
$SETUP_DIR \
$SYNC_DIR \
$BAK_DIR \
$PROJECTS_DIR \
$GITHUB_DIR\
"

for DIR in $DIRECTORIES
do
    if ! [ -d $DIR ]; then
        echo 'creating '$DIR' dir'
        mkdir $DIR
    fi
done

get_local_git_repo ()
{

    if ! [ -d $GITHUB_DIR/local ]; then
        chmod -R 777 $GITHUB_DIR/local
        rm -r $GITHUB_DIR/local
    fi
    cd $GITHUB_DIR
    git clone git@github.com:kixxauth/local.git
}

exit 0

