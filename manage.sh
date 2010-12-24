#!/bin/bash

# Git repos
PROJECTS_DIR=$HOME/projects
GITHUB_DIR=$PROJECTS_DIR/github

GITS="\
$GITHUB_DIR/local \
"
# TODO This should be read in from an external list file.
MY_PACKS="\
build-essential \
curl \
elinks \
flashplugin-nonfree \
gimp \
git-core \
iotop \
irssi \
keepassx \
libssl0.9.8 \
libssl-dev \
mercurial \
mplayer \
ncftp \
openssh-client \
openssh-server \
subversion \
sun-java6-jre \
sun-java6-plugin \
sun-java6-fonts \
tree \
vim-gnome \
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
$GITHUB_DIR \
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

exit_msg ()
{
    echo "try:"
    echo "sync - sync machines and update locally"
    echo "update - update packages"
    echo "bin - update local scripts"
    echo "pkgs - install distro packages"
    echo "etcbak - backup the /etc dir (pass file name)"
    echo "bootstrap - setup local git repo and scripts"
}

must_be_sudo ()
{
    if [ "$(id -u)" != "0" ]; then
        echo 'this function must be run as root'
        exit 1
    fi
}

must_not_sudo ()
{
    if [ "$(id -u)" == "0" ]; then
        echo 'this function must *not* be run as root'
        exit 1
    fi
}

get_local_git_repo ()
{
    must_not_sudo
    if [ -d $GITHUB_DIR/local ]; then
        echo 'deleting previous '$GITHUB_DIR/local
        chmod -R 777 $GITHUB_DIR/local
        rm -r $GITHUB_DIR/local
    fi
    echo 'cloning git@github.com:kixxauth/local.git'
    cd $GITHUB_DIR
    git clone git@github.com:kixxauth/local.git
}

update_local_git_repo ()
{
    must_not_sudo
    echo 'pulling local git repo from Github'
    cd $GITHUB_DIR/local
    git pull origin master
}

backup_etc ()
{
    must_be_sudo
    namex="bak_"
    if [ -n "$1" ]; then
        echo concat
        namex="$namex$1_"
    fi

    full_name=$BAK_DIR/etc-$namex$DATE_TODAY.tar.bz2
    echo 'backing /etc up to '$full_name
    tar -cjf $full_name /etc
}

update_packages ()
{
    must_be_sudo
    echo 'Updating applications:'
    apt-get update
    apt-get upgrade --fix-missing --assume-yes
}

cleanup_packages ()
{
    must_be_sudo
    apt-get check
    apt-get autoremove --fix-missing --assume-yes
    apt-get clean
    apt-get autoclean
}

install_packages ()
{
    must_be_sudo
    echo 'Installing essential applications:'
    echo $MY_PACKS
    apt-get install --fix-missing --assume-yes --auto-remove $MY_PACKS
}

update_bin_scripts ()
{
    must_not_sudo

    # update the rsync exclude list
    echo 'updating '$SYNC_DIR'/sync.list'
    cp $GITHUB_DIR/local/system_sync/sync.list $SYNC_DIR/sync.list

    # update the rsync script
    echo 'updating '$BIN_DIR'/syncpull'
    cp $GITHUB_DIR/local/system_sync/syncpull.sh $BIN_DIR/syncpull
    chmod 764 $BIN_DIR/syncpull

    # update the firefox scripts
    echo 'updating '$BIN_DIR'/firefox_dev'
    cp $GITHUB_DIR/local/firefox_dev.sh $BIN_DIR/firefox_dev
    chmod 764 $BIN_DIR/firefox_dev
    echo 'updating '$BIN_DIR'/firefox_user'
    cp $GITHUB_DIR/local/firefox_user.sh $BIN_DIR/firefox_user
    chmod 764 $BIN_DIR/firefox_user

    # update this script
    echo 'updating '$BIN_DIR'/manage'
    cp $GITHUB_DIR/local/manage.sh $BIN_DIR/manage
    chmod 764 $BIN_DIR/manage
}

if [ -z "$1" ]; then
    echo "exiting without running anything "
    exit_msg
    exit 0
fi

if [ $1 = 'sync' ]; then
    if [ -z $2 ]; then
        echo "the sync command needs a parameter"
        exit_msg
        exit 1
    fi
    update_local_git_repo
    update_bin_scripts
    syncpull $2 $SYNC_DIR
    if [ $? != '0' ]; then
        echo "exiting"
        exit $?
    fi
    vim $SYNC_DIR/sync.log
    exit 0
fi

if [ $1 = 'bin' ]; then
    update_local_git_repo
    update_bin_scripts
    exit 0
fi

if [ $1 = 'update' ]; then
    update_packages
    cleanup_packages
    exit 0
fi

if [ $1 = 'pkgs' ]; then
    install_packages
    update_packages
    cleanup_packages
    echo "You may want to run 'bin' or 'bootstrap' before 'pkgs'"
    exit 0
fi

if [ $1 = 'etcbak' ]; then
    backup_etc $2
    exit 0
fi

if [ $1 = 'bootstrap' ]; then
    get_local_git_repo
    update_bin_scripts
    exit 0
fi

echo "invalid function call: "$1
exit_msg
exit 1
