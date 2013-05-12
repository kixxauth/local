Mac OS X Setup
==============

## Chrome Browser
Use Safari to get it, and get Firefox while you're at it. Also, you need the
account credentials for kristoffwalk@gmail.com to setup the sync system in
Chrome.

## iTerm
Get it: [home page](http://www.iterm2.com/)

Once you've got it downloaded, move it over to the root `/Applications/`
directory.

We're not going to spend time
[tweaking it out](http://www.iterm2.com/#/section/features)
now, but that'll be a fun way to kill an afternoon later.

# Dropbox
Just keep in mind that it will take a while to download all your files.  Also,
you'll need the Dropbox credentials from KeePass on another machine.

## Setupstick
Plugin a USB drive on another machine and run `ksys setupstick` to transfer SSH
keys and the setup.py script to it. Tranfer the USB stick to the target machine
and copy the setup.py script to the home directory. You can find it at
`/Volumes/KEYS/setup.py`.

## Setup
Next, run the setup script with

	python ~/setup.py

It will install the SSH keys from the setupstick, the master .gitconfig and
.gitignore files, pull the local repository, and create symlinks the to local
ksys commands.

## Setup-Mac
Next, run the Mac setup script

	ksys setupmac

which will install the dotfiles, homebrew, and the newer version of git (via
Homebrew).

## MacVim
Follow the instructions in `/docs/macvim.md`.

## KeePassX
[Website](http://www.keepassx.org). Don't use version 2.