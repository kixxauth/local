#!/bin/bash

fail () {
	echo "$@" >&2
	exit 1
}

super_user () {
    [ "$(id -u)" == "0" ] || return 1
}

super_or_fail () {
    local msg="$1"
    super_user || fail "Super user priv required $msg"
}

ensure_dir () {
    if ! [ -d "$1" ]; then
        mkdir -p -- "$1" || fail "couldn't create $1"
    fi
}
