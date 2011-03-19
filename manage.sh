#!/bin/bash

# Git repos
PROJECTS_DIR=$HOME/development
GITHUB_DIR=$PROJECTS_DIR/github

GITS="\
$GITHUB_DIR/local \
"
# TODO This should be read in from an external list file.
MY_PACKS="\
build-essential \
curl \
elinks \
dkms \
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
unrar
"
PURGED_PACKS="\
apt-xapian-index \
tomboy \
evolution \
f-spot \
rhythmbox \
totem \
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
DIRECTORY=$(cd `dirname $0` && pwd)

create_dirs ()
{
    for DIR in $DIRECTORIES
    do
        if ! [ -d $DIR ]; then
            echo 'creating '$DIR' dir'
            mkdir $DIR
        fi
    done
}

exit_msg ()
{
    echo "try:"
    echo "bak - backup and version the local home dir [commit_msg]"
    echo "rbak - backup remote directories [last IP digit] [commit_msg]"
    echo "sync - sync machines and update locally [last IP digit]"
    echo "update - update packages"
    echo "bin - update local scripts"
    echo "pkgs - install distro packages"
    echo "etcbak - backup the /etc dir [file name part]"
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
    apt-get dist-upgrade --fix-missing --assume-yes
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
    apt-get install --fix-missing --assume-yes --auto-remove $MY_PACKS
    echo 'Installed essential applications:'
    echo $MY_PACKS
}

prune_packages ()
{
    must_be_sudo
    apt-get purge --fix-missing --assume-yes --auto-remove $PURGED_PACKS
    echo 'Removed unused packages:'
    echo $PURGED_PACKS
}

update_bin_scripts ()
{
    must_not_sudo

    # update the rsync exclude list
    echo 'updating '$SYNC_DIR'/sync.list'
    cp $GITHUB_DIR/local/rsync_lists/sync.list $SYNC_DIR/sync.list

    # updating the main backup exclude list
    echo 'updating '$SYNC_DIR'/main_bak.list'
    cp $GITHUB_DIR/local/rsync_lists/main_bak.list $SYNC_DIR/main_bak.list

    # updating the toshiba backup exclude lists
    echo 'updating '$SYNC_DIR'/toshiba_A8-kris-bak.list'
    cp $GITHUB_DIR/local/rsync_lists/toshiba_A8-kris-bak.list $SYNC_DIR/toshiba_A8-kris-bak.list
    cp $GITHUB_DIR/local/rsync_lists/toshiba_A8-jocelyn-bak.list $SYNC_DIR/toshiba_A8-jocelyn-bak.list

    # update the rsync script
    echo 'updating '$BIN_DIR'/syncpull'
    cp $GITHUB_DIR/local/syncpull.sh $BIN_DIR/syncpull
    chmod 764 $BIN_DIR/syncpull

    # update the firefox scripts
    echo 'updating '$BIN_DIR'/firefox_dev'
    cp $GITHUB_DIR/local/firefox_dev.sh $BIN_DIR/firefox_dev
    chmod 764 $BIN_DIR/firefox_dev
    echo 'updating '$BIN_DIR'/firefox_user'
    cp $GITHUB_DIR/local/firefox_user.sh $BIN_DIR/firefox_user
    chmod 764 $BIN_DIR/firefox_user

    # update utility scripts
    echo 'updating '$BIN_DIR'/find_swap_files'
    cp $GITHUB_DIR/local/find_swap_files.sh $BIN_DIR/find_swap_files
    chmod 764 $BIN_DIR/find_swap_files
    echo 'updating '$BIN_DIR'/del_swap_files'
    cp $GITHUB_DIR/local/del_swap_files.sh $BIN_DIR/del_swap_files
    chmod 764 $BIN_DIR/del_swap_files

    # update this script
    echo 'updating '$BIN_DIR'/manage'
    cp $GITHUB_DIR/local/manage.sh $BIN_DIR/manage
    chmod 764 $BIN_DIR/manage
}

# $1 repo dir
# $2 commit msg
git_version ()
{
    must_not_sudo

    cd $1
    git checkout master
    if [ $? != '0' ]; then
        echo "exiting"
        return $?
    fi

    git add .
    if [ -z "$2" ]; then
        git commit -m "$(date)"
    else
        git commit -m "$2"
    fi
}

# $1 source
# $2 destination
# $3 logfile
# $4 exlude list
versioned_backup ()
{
    must_not_sudo

    # Check the source
    # TODO: This does not work for things like `kixx@192.168.1.2:~/`
    #if ! [ -d $1 ]; then
    #    echo 'could not find the source at '$1
    #    return 1
    #fi

    # Check the destination
    if ! [ -d $2 ]; then
        echo 'could not find the destination '$2
        return 1
    fi

    # Remove the previous log
    if [ -f $3 ]; then
        echo 'removing previous log file from '$3
        rm $3
    fi

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

    # Check for the sync.list
    if [ -n "$4" ]; then
        if ! [ -f $4 ]; then
            echo 'could not find the exlude list at '$4
            echo 'try running the update script first'
            return 1
        else
            rsync \
            --recursive \
            --links \
            --perms \
            --times \
            --group \
            --owner \
            --progress \
            --human-readable \
            --exclude-from=$4 \
            --log-file=$3 \
            $1/ $2/
        fi
    else
        rsync \
        --recursive \
        --links \
        --perms \
        --times \
        --group \
        --owner \
        --progress \
        --human-readable \
        --log-file=$3 \
        $1/ $2/
    fi
}

if [ -z "$1" ]; then
    echo "exiting without running anything "
    exit_msg
    exit 0
fi

if [ $1 = 'bak' ]; then
    create_dirs
    update_local_git_repo
    update_bin_scripts
    versioned_backup $HOME /archive/bak/kris/main/tree /archive/bak/kris/main/latest.log $SYNC_DIR/main_bak.list
    if [ $? != '0' ]; then
        echo "exiting"
        exit $?
    fi
    git_version /archive/bak/kris/main/ $2
    rsync \
    --recursive \
    --links \
    --perms \
    --times \
    --group \
    --owner \
    --progress \
    --human-readable \
    ~/.VirtualBox/ /archive/bak/kris/virtual_machines/VirtualBox/
    exit $?
fi

if [ $1 = 'rbak' ]; then
    if [ -z $2 ]; then
        echo "the rbak command needs the last digit of the target IP"
        exit_msg
        exit 1
    fi
    create_dirs
    update_local_git_repo
    update_bin_scripts
    versioned_backup kixx@192.168.1.$2:~/ /archive/bak/kris/toshiba_A8/tree/ /archive/bak/kris/toshiba_A8/latest.log $SYNC_DIR/toshiba_A8-kris-bak.list
    if [ $? != '0' ]; then
        echo "exiting"
        exit $?
    fi
    git_version /archive/bak/kris/toshiba_A8/ $3
    versioned_backup jocelyn@192.168.1.$2:~/ /archive/bak/jocelyn/toshiba_A8/tree/ /archive/bak/jocelyn/toshiba_A8/latest.log $SYNC_DIR/toshiba_A8-jocelyn-bak.list
    if [ $? != '0' ]; then
        echo "exiting"
        vim /archive/bak/kris/toshiba_A8/latest.log
        exit $?
    fi
    versioned_backup jocelyn@192.168.1.$2:~/Pictures /archive/media/img/jocelyn/Pictures/ /archive/media/img/jocelyn/Pictures/latest.log
    if [ $? != '0' ]; then
        echo "exiting"
        vim /archive/bak/kris/toshiba_A8/latest.log /archive/bak/jocelyn/toshiba_A8/latest.log
        exit $?
    fi
    versioned_backup jocelyn@192.168.1.$2:~/Videos /archive/media/video/jocelyn/Videos/ /archive/media/video/jocelyn/Videos/latest.log
    if [ $? != '0' ]; then
        echo "exiting"
        vim /archive/bak/kris/toshiba_A8/latest.log /archive/bak/jocelyn/toshiba_A8/latest.log /archive/media/img/jocelyn/Pictures/latest.log
        exit $?
    fi
    vim /archive/bak/kris/toshiba_A8/latest.log /archive/bak/jocelyn/toshiba_A8/latest.log /archive/media/img/jocelyn/Pictures/latest.log /archive/media/video/jocelyn/Videos/latest.log
    exit $?
fi

if [ $1 = 'sync' ]; then
    if [ -z $2 ]; then
        echo "the sync command needs the last digit of the target IP"
        exit_msg
        exit 1
    fi
    create_dirs
    update_local_git_repo
    update_bin_scripts
    ~/local/bin/syncpull $2 $SYNC_DIR
    if [ $? != '0' ]; then
        echo "exiting"
        exit $?
    fi
    vim $SYNC_DIR/sync.log
    exit 0
fi

if [ $1 = 'bin' ]; then
    create_dirs
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
    prune_packages
    install_packages
    update_packages
    cleanup_packages
    echo "You may want to run 'bin' or 'bootstrap' before 'pkgs'"
    exit 0
fi

if [ $1 = 'etcbak' ]; then
    create_dirs
    backup_etc $2
    exit 0
fi

if [ $1 = 'bootstrap' ]; then
    create_dirs
    get_local_git_repo
    update_bin_scripts
    cd $DIRECTORY
    rm $0
    exit 0
fi

echo "invalid function call: "$1
exit_msg
exit 1

