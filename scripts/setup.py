# Usage: python setup.py
# Summary: Istall setup files from a USB stick.
# Help: Copies SSH keys, toehold script, and other goodies onto the local
# machine from a specialized USB stick. This is not just for initializing a new
# machine; it can be used to update an existing setup.

import sys
import os
import shutil
import textwrap
import subprocess

LOCAL_REPO = 'git@github.com:kixxauth/local.git'

def main():
    source = key_usb_path()

    if not os.path.isdir(source):
        exit("""\
                Source path '%s' does not exist.
                Is the drive plugged in?""" % source)

    home = os.path.expanduser('~')

    # Copy SSH keys.
    ssh_src = os.path.join(source, 'ssh')
    ssh_target = os.path.join(home, '.ssh')
    replace_dir(ssh_src, ssh_target)
    os.chmod(ssh_target, 0700)
    if subprocess.call('chmod 600 ~/.ssh/*', shell=True) is not 0:
        exit("""\
                There was an error while setting permissions on the .ssh directory.
                Exiting.""")

    # Copy .gitconfig.
    gitconfig = os.path.join(home, '.gitconfig')
    shutil.copy(os.path.join(source, '.gitconfig'), gitconfig)
    os.chmod(gitconfig, 0640)
    print "Installed global .gitconfig"

    # Copy .gitignore.
    gitignore = os.path.join(home, '.gitignore_master')
    shutil.copy(
            os.path.join(source, '.gitignore_master'),
            gitignore)
    os.chmod(gitignore, 0664)
    print "Installed global .gitconfig"

    # Pull the 'local' repository.
    # Don't bother automatically cloning the "local" repo - 2017-04-23
    #
    # rprojects = os.path.join(home, 'Rprojects')
    # if not os.path.isdir(rprojects):
    #     os.mkdir(rprojects)

    # localrepo = os.path.join(rprojects, 'local')
    # if not os.path.isdir(localrepo):
    #     os.chdir(rprojects)
    #     if subprocess.call(['git', 'clone', LOCAL_REPO]) is not 0:
    #         exit("""\
    #                 There was a problem cloning the git repo.
    #                 Exiting.""")
    # else:
    #     print "Local git repo already exists; not pulling."

    # Install the local subs.
    # Don't bother installing the sub commands - 2017-04-23
    #
    # subprocess.call(os.path.join(localrepo, 'install'), shell=True)

    print "Done."


def key_usb_path():
    if sys.platform == 'darwin':
        return '/Volumes/KEYS'
    if sys.platform == 'linux2':
        return '/media/kris/KEYS'
    return None


def exit(msg):
    sys.exit(textwrap.dedent(msg))


def replace_dir(src, target):
    if os.path.isdir(target):
        shutil.rmtree(target)

    shutil.copytree(src, target)


if __name__ == '__main__':
    main()
