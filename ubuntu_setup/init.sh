#!/bin/bash
nosync=$HOME/nosync
setup=$nosync/setup
HOME_LOCAL=$HOME/local
HOME_LOCAL_BIN=$HOME_LOCAL/bin
BAK=$nosync/bak
bak_etc=$BAK/install-conf-bak.tar.bz2

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
    mkdir $BACK
fi

# Create the setup sub dir in nosync
if [ -d $setup ]; then
    echo $setup' dir already created'
else
    echo 'creating '$setup' dir'
    mkdir $setup
fi

# Move this script
if [ -f $HOME/init.sh ]; then
    mv $HOME/init.sh $setup/
fi

# Backup the /etc config dir while it's still fresh.
if [ -f $bak_etc ]; then
    echo '/etc has already been backed up to '$bak_etc
else
    echo 'making backup of /etc'
    tar -cjf $bak_etc /etc
fi

# Download the rsync script
if ! [ -f $HOME_LOCAL_BIN/syncpull ]; then
    echo 'getting syncpull.sh from GitHub'
    wget http://github.com/kixxauth/scripts/raw/master/syncpull.sh $HOME_LOCAL_BIN/syncpull
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
    wget http://github.com/kixxauth/scripts/raw/master/ubuntu-packages.sh $setup/ubuntu-packages.sh
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
