import sys
from os import path
import shutil
import textwrap


def exit(msg):
    sys.exit(textwrap.dedent(msg))


def replace_dir(src, target):
    if path.isdir(target):
        shutil.rmtree(target)

    shutil.copytree(src, target)
