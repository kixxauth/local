#!/usr/bin/python

"""
Display the per-commit size of the current git branch.
"""

import subprocess
import re
import sys

def main(argv):
  git = subprocess.Popen(["git", "log", "--shortstat", "--reverse",
                        "--pretty=oneline"], stdout=subprocess.PIPE)
  out, err = git.communicate()
  total_files, total_insertions, total_deletions = 0, 0, 0
  for line in out.split('\n'):
    if not line: continue
    if line[0] != ' ': 
      # This is a description line
      hash, desc = line.split(" ", 1)
    else:
      # This is a stat line
      data = re.findall(
        ' (\d+) files changed, (\d+) insertions\(\+\), (\d+) deletions\(-\)', 
        line)
      files, insertions, deletions = ( int(x) for x in data[0] )
      total_files += files
      total_insertions += insertions
      total_deletions += deletions
      print "%s: %d files, %d lines" % (hash, total_files,
                                        total_insertions - total_deletions)


if __name__ == '__main__':
  sys.exit(main(sys.argv))
