#!/bin/bash
source "$LIBDIR/utils.sh"

super_or_fail 'to update system'

apt-get update \
    || fail "Unable to update system"
apt-get dist-upgrade --fix-missing --assume-yes \
    || fail "Unable to dist-upgrade system"
