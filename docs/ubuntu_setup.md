Upgrading an Ubuntu installation
================================

Get Ubuntu
----------
Download the iso (or get it from the local archive) and then burn to CDROM.


Backup
------

### Pull Remote

	k sync push
	k sync pull-delete

### Backup /etc

	ksys backup-etc

### Sync Laptop with Back Office
Use `k sync push` and `k sync pull`.

### Home Directory
Make sure to use snapbak on the back office machine, even if it's just a laptop
getting upgraded.

	k snapbak

And then backup any virtual machine disks that might be needed as well.

### External Backup

Plugin the external drive and do the normal incremental backups by running
`/archive/inc_tar.sh`.  Then backup any virtual machine disks that might be
needed.

### Record Disk Usage

	sudo blkid >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo du -sh / >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo du -sh ~/ >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo du -sh ~/Dropbox/ >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo du -sh /archive/ >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo df -h /dev/sda1 >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo df -h /dev/sdb1 >> /home/kixx/Dropbox/temp/disk-usage.txt
	sudo df -h /dev/sdb5 >> /home/kixx/Dropbox/temp/disk-usage.txt

Also use the Ubuntu Disk Usage Analyzer and pay close attention to the virtual
machines.


Create Boot Stick
-----------------
Insert the setup USB drive and run:

	ksys setupstick

See the `create_bootstick` docs for more info.


Hardware Prep
-------------
* 2011-DESKTOP: Unplug backup drive before working on SDD drive
* 2011-DESKTOP: Master SSD SATA port must be configured from BIOS
* 2011-DESKTOP: Bootable install CD runs from DVD/CD drive
* ToshibaA8: Press esc on boot and then F1 to get to BIOS
* ToshibaA8: Choose to boot from CDRom.
* 2007-DESKTOP: Install disks need to run from the TDK writer drive.
* 2007-DESKTOP: BIOS is ready to boot from either CDRom drive.


Begin
-----
Shutdown the machine.


### Prep Disk
Zero out the disks
[(see article)](http://linuxhelp.blogspot.com/2006/06/how-to-securely-erase-hard-disk-before.html).
This is done by booting the machine with the Ubuntu boot disk but before any
new software is installed. Choose the 'Try Ubuntu' option when the bootable CD
loads and then open a terminal and run the following commands:

	sudo fdisk -l
	sudo blkid
	sudo shred -vfz -n 1 /dev/sdb


### Ubuntu Install Notes
* Note: multiple distro installations see: mhvlug Digest, Vol 26, Issue 14 (mailing list)
* Always do advanced/manual disk partitioning (option: "something else") on Ubuntu install disk. (except when backup drive is unplugged and installing on SSD)


Initial Setup on Fresh Install
------------------------------

### 1. Auto Update
Shut off auto update on update manager in Gnome.

### 1. Setup SSH keys and Configs
First, copy the .ssh directory from the bootstick USB drive, then:

	sudo chown -R kris:kris ~/.ssh/  
	chmod 700 ~/.ssh/  
	chmod 600 ~/.ssh/*  

Then copy .gitconfig and .gitignore_master to `~/` and `chown kris:kris` on them.

### 2. Install Git

	sudo apt-get install git-core

### 3. Run the setup script

	python /media/kris/KEYS/setup.py

### 3. Update Ubuntu  
Edit /etc/apt/sources.list to include all packages except the CDROM.

	ksys backup-etc 								# Backup /etc directory into ~/Downloads/
	sudo vi /etc/apt/sources.list 	# Uncomment the partner repositories. 

	sudo apt-get update
	sudo apt-get dist-upgrade

### 4. Add Ubuntu Packages

	sudo apt-get --no-install-recommends --assume-yes install \
		build-essential \
		curl \
		vim \
		tree \
		git-core \
		dkms \
		openssl \
		libssl-dev \
		openssh-server \
		ncftp

### 5. Clean up Apt

	sudo apt-get autoremove
	sudo apt-get autoclean

### 6. Dotfiles
Clone the dotfiles repository into `Rprojects/` and follow the instructions in
the README.

	git clone git@github.com:kixxauth/dotfiles.git

### 7. Reboot  
Remember to change the boot preference in BIOS when rebooting. Then, after
logging in again run:

	ksys backup-etc

### 8. Setup Archive
Create the directory:

    sudo mkdir /archive
    sudo chown kris:kris /archive

Then mount the Data Warehouse partition:

    sudo blkid
    sudo vim /etc/fstab

    # archive on /dev/sda1
    UUID=ce993001-34fe-4040-b1aa-230b970a0552 /archive           ext4    relatime        0       3

Pull Remote File Sync
---------------------

	k sync pull

Pull Remote Repositories
------------------------

	k repos

Monitors and Nvidia driver
--------------------------
Open Software Updates > Additional Drivers and install the latest Nvidia
driver.  Then use the system settings displays feature to set up the monitors.

Google Chrome Browser
---------------------
Install dependency

	sudo apt-get install libxss1

Then use Firefox to download the debian package, then install it.

Node.js is our scripting engine:
--------------------------------
Install node.js and npm all in one go:

	sudo apt-get install g++ curl libssl-dev apache2-utils git-core
	cd Rprojects/Reference/node/
	git tag
	git checkout [TAG]
	./configure
	make
	sudo make install

*To uninstall npm*

    `:$ npm uninstall npm`

*To uninstall Node.js*

    `:$ make uninstall`

Dropbox
-------
Install it and leave plenty of time to import data.

Passwords
---------
Install KeePass with

	sudo apt-get install keepassx

Text Editor
-----------
Sublime

Virtual Machines
----------------
### Virtualbox

Install from the [download page](https://www.virtualbox.org/wiki/Linux_Downloads).
Then install dependencies:

	sudo apt-get install libsdl1.2debian
	sudo dpkg -i virtualbox-4.3_4.3.6-75467~Ubuntu~lucid_amd64.deb

### Vagrant
Install from the [download page](http://www.vagrantup.com/downloads.html).


Firefox
-------
*Deprecated (use Ubuntu stock Firefox)*

    :$ cd local/sbin/
    :$ ncftp ftp://releases.mozilla.org/pub/mozilla.org/firefox/releases/
    :$ tar -xjvf $FIREFOX_TAR

Additional requirement for 64 bit (try without first)

    :$ sudo apt-get install ia32-libs

Or try one of:

    :$ sudo apt-get install ia32-libs lib32asound2 lib32ncurses5 ia32-libs-sdl ia32-libs-gtk gsfonts gsfonts-x11 linux32

Long Running SSH Sessions
-------------------------
http://ocaoimh.ie/how-to-fix-ssh-timeout-problems/ -- As root on your desktop
(or client) machine, edit `/etc/ssh/ssh_config` and add the line:

    ServerAliveInterval 60

This should all be available in the last etc/ backup.

64 bit flashplugin
------------------

*The flash plugin is only needed for Firefox, Chrome includes its own.*

    :$ sudo add-apt-repository ppa:sevenmachines/flash
    :$ sudo apt-get update
    :$ sudo apt-get install flashplugin64-installer

Printing
--------
### Brother 4750e

    :$ sudo apt-get install brother-lpr-drivers-laser1

Amazon mp3 downloader
---------------------
    `wget https://launchpadlibrarian.net/26959932/libboost-signals1.34.1_1.34.1-16ubuntu1_i386.deb `
    `https://launchpadlibrarian.net/26959936/libboost-thread1.34.1_1.34.1-16ubuntu1_i386.deb `
    `https://launchpadlibrarian.net/26959922/libboost-iostreams1.34.1_1.34.1-16ubuntu1_i386.deb `
    `https://launchpadlibrarian.net/26959918/libboost-filesystem1.34.1_1.34.1-16ubuntu1_i386.deb `
    `https://launchpadlibrarian.net/26959916/libboost-date-time1.34.1_1.34.1-16ubuntu1_i386.deb `
    `https://launchpadlibrarian.net/26959928/libboost-regex1.34.1_1.34.1-16ubuntu1_i386.deb `
    `https://launchpadlibrarian.net/34165098/libicu40_4.0.1-2ubuntu2_i386.deb`

http://www.amazon.com/gp/dmusic/help/amd.html/

