#!/bin/bash
# 
# Syncing two directories on a local filesystem, but skipping .* hidden files.
#
# This is good for moving git repos around but excluding the .git stuff and
# other hidden files.
#
rsync -av --delete --filter="- .*" $1 $2
