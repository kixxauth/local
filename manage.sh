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

# Handy to have around
DATE_TODAY="$(date +%Y-%m-%d)"

for DIR in $DIRECTORIES
do
    if ! [ -d $DIR ]; then
        echo 'creating '$DIR' dir'
        mkdir $DIR
    fi
done

get_local_git_repo ()
{
    if [ -d $GITHUB_DIR/local ]; then
        echo 'deleting previous '$GITHUB_DIR/local
        chmod -R 777 $GITHUB_DIR/local
        rm -r $GITHUB_DIR/local
    fi
    echo 'cloning git@github.com:kixxauth/local.git'
    cd $GITHUB_DIR
    git clone git@github.com:kixxauth/local.git
}

backup_etc ()
{
    if [ "$(id -u)" != "0" ]; then
        echo 'this function must be run as root'
        exit 1
    fi
    namex="bak_"
    if [ -n $1 ]; then
        namex="$namex$1_"
    fi

    full_name=$BAK_DIR/etc-$namex$DATE_TODAY.tar.bz2
    echo 'backing /etc up to '$full_name
    tar -cjf $full_name /etc
}

exit_msg ()
{
    echo "try:"
    echo "bootstrap - download the local git repo"
    echo "etcbak - backup the /etc dir (pass file name)"
}

if [ -z $1 ]; then
    echo "exiting without running anything "
    exit_msg
    exit 0
fi

if [ $1 = 'bootstrap' ]; then
    get_local_git_repo
    exit 0
fi

if [ $1 = 'etcbak' ]; then
    backup_etc $2
    exit 0
fi

echo "invalid function call: "$1
exit_msg
exit 1

