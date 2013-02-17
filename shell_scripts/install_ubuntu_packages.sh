#!/bin/bash
source "$LIBDIR/utils.sh"

super_or_fail 'to install packages'

if [ -z $1 ]; then
    fail "$0: packages argument is required"
fi

apt-get install --assume-yes --fix-missing $@ \
    || fail "$0: could not complete install"
apt-get autoremove --assume-yes --fix-missing \
    || fail "$0: could not complete autoremove"
apt-get clean \
    || fail "$0: could not complete clean"

echo "installed: $@"
