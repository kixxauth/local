#!/bin/bash
# Run as sudo to start setup
echo 'Installing essential applications:'
apt-get install --fix-missing --assume-yes --auto-remove \
build-essential \
vim-gnome \
openssh-client \
openssh-server \
libssl0.9.8 \
libssl-dev \
tree \
iotop \
git-core \
mercurial \
subversion \
curl \
ncftp \
flashplugin-nonfree \
keepassx \
sun-java6-jre \
sun-java6-plugin \
sun-java6-fonts \
gimp \
irssi
apt-get update
apt-get upgrade
