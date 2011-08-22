#!/bin/bash
basepath="$HOME/local/sbin/firefox"

if [ -d /Applications/Firefox.app ]; then
    basepath="/Applications/Firefox.app/Contents/MacOS"
fi

"$basepath/firefox" -no-remote -P "$1"
