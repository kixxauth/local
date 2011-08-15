# Search and replace (recursively) with egrep and sed
#
# The pattern to egrep just needs to be close enough to match the desired lines
# in the files.
#
# The pattern to sed is much like most search and replace patterns.
#
egrep -lRZ "\.jpg|\.png|\.gif" . | xargs -0 -l sed -i -e 's/\.jpg\|\.gif\|\.png/.bmp/g'
