#!/bin/bash
# Run as sudo to start setup
echo 'Installing essential applications:'
apt-get install --fix-missing --assume-yes --auto-remove \
build-essential \
curl \
dkms \
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
vim-gnome
apt-get update
apt-get upgrade --fix-missing --assume-yes
