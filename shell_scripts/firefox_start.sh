#!/bin/bash
if [ -d /Applications/Firefox.app ]; then
    cd /Applications/Firefox.app/Contents/MacOS/
else
    cd $HOME/local/sbin/firefox5/
fi
./firefox -no-remote -P $1
