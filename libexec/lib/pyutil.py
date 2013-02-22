import sys
from os import path
import subprocess
import shutil
import textwrap


def sub_or_exit(cmd, errmsg):
    args = cmd.split()
    if subprocess.call(args) is not 0:
        exit(errmsg)

def shell(cmd):
    return subprocess.call(cmd, shell=True)

def exit(msg):
    sys.exit(textwrap.dedent(msg))


def replace_dir(src, target):
    if path.isdir(target):
        shutil.rmtree(target)

    shutil.copytree(src, target)
