#!/bin/bash
nosync=$HOME/nosync
setup=$nosync/setup
HOME_LOCAL=$HOME/local
HOME_LOCAL_BIN=$HOME_LOCAL/bin
BAK=$nosync/bak

# Create the local dir
if [ -d $HOME_LOCAL ]; then
    echo $HOME_LOCAL' dir already created'
else
    echo 'creating '$HOME_LOCAL' dir'
    mkdir $HOME_LOCAL
fi

# Create the local bin dir
if [ -d $HOME_LOCAL_BIN ]; then
    echo $HOME_LOCAL_BIN' dir already created'
else
    echo 'creating '$HOME_LOCAL_BIN' dir'
    mkdir $HOME_LOCAL_BIN
fi

# Create the nosync dir
if [ -d $nosync ]; then
    echo $nosync' dir already created'
else
    echo 'creating '$nosync' dir'
    mkdir $nosync
fi

# Create the bak sub dir in nosync
if [ -d $BAK ]; then
    echo $BAK' dir already created'
else
    echo 'creating '$BAK' dir'
    mkdir $BAK
fi

# Create the setup sub dir in nosync
if [ -d $setup ]; then
    echo $setup' dir already created'
else
    echo 'creating '$setup' dir'
    mkdir $setup
fi

# Download the rsync script
if ! [ -f $HOME_LOCAL_BIN/syncpull ]; then
    echo 'getting syncpull.sh from GitHub'
    wget --no-check-certificate --output-document=$HOME_LOCAL_BIN/syncpull https://github.com/kixxauth/local/raw/master/system_sync/syncpull.sh
    if [ -f $HOME_LOCAL_BIN/syncpull ]; then
        chmod 764 $HOME_LOCAL_BIN/syncpull
    else
        echo 'unable to download syncpull.sh from GitHub'
    fi
else
    echo 'syncpull.sh already downloaded'
fi

# Download the applications installation script
if ! [ -f $setup/ubuntu-packages.sh ]; then
    echo 'getting ubuntu-packages.sh from GitHub'
    wget --no-check-certificate --output-document=$setup/ubuntu-packages.sh https://github.com/kixxauth/local/raw/master/ubuntu_setup/ubuntu-packages.sh
    if [ -f $setup/ubuntu-packages.sh ]; then
        chmod 764 $setup/ubuntu-packages.sh
    else
        echo 'unable to download ubuntu-packages.sh from GitHub'
        # We can't go on.
        exit
    fi
else
    echo 'ubuntu-packages.sh already downloaded'
fi

# Move this script
if [ -f $HOME/init.sh ]; then
    mv $HOME/init.sh $setup/
fi
