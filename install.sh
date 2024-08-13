#!/usr/bin/env bash
this="$(cd `dirname "$0"` && pwd)"

if [ ! -d "/usr/local/bin" ]; then
	sudo mkdir -p /usr/local/bin
fi

k="/usr/local/bin/k"
if [ ! -f $k ]; then
    sudo ln -s "$this/libexec/k" $k
fi

ksys="/usr/local/bin/ksys"
if [ ! -f $ksys ]; then
    sudo ln -s "$this/libexec/ksys" $ksys
fi

echo "Local subs installed."
