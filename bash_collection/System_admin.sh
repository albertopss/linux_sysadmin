#!/bin/bash
#su command open a shell as root user
#sudo command  a regular user is given root privileges
#Cockpit
###################################333
#Features that is expected to manage
#1)Fylesystems
#2)Software installation
#3)User accounts
#4)Network interfaces
#5)Servers
#6)Security features
###################################
#su - to change directories or the enviroment of the current session
#su - usseracount to have the permissions of some account
#sudoers is the most common way to provide privilege
#Adding lines to sudoers and allow privileges
#joe   ALL=(ALL)      ALL
#To allow privileges without passwd: joe ALL(ALL)     ALL
#You can make sudo group, give privileges and add users
#####################################
###Administrative Commands
#/sbin contained commands needed to boot the system and check fylesystem
#/usr/sbin contained commands for managing user account(useradd, daemons)
#Some admin commands are contained in regular user directories
#as /bin & /usr/bin
#####################################
###Administrative configuration files
#/home - directs how their login accounts behave
#/etc - contained most of basic linux configuration files
#like /etc/security /systemd or aliases bashrc passwd sudoers cron
######################################
###Adminsitrative log files & systemd journal
#You need to be able to refer messages comming from kernel and services
#Facilities like systemd journal (journalctl) :
#journalctl --list boots   journalctl -k
#For specific service : jorunalctl _SYSTEM_UNIT=sshd.service
#Only emergency messages journalctl PRIORITY=0 (0-7)
######################################
##Others adminstrative accounts
#Provide ownership for files and process of particular service
# lp   apache    avahi   bin
######################################
###CHECKING & CONF HARDWARE
##Check devices udev (user device management)
#rules re contained /etc/udev/rules.d
#/dev/ udevd deamon creates and remove devices
###dmesg      or     journalctl
#dmesg | less
#If some goes wrong detecting hardware or loading drivers 
##
#lspci lsusb lscpu neofetch
#####################################
###KERNEL MODULES
##are located /lib/modules or lsmod
##LOADING MODULES
##modprobe loads temporarily
#rmmod or modprobe -r
#####################################
###ADDING REPOSITORIES
##apt add-apt-repository "url"
##vi /etc/apt/sources.list /etc/pacman.conf
##synapctic for graphical
#####################################
####Managing accounts
#useradd -m -k -s -c default values /etc/login.defs or /etc/default/useradd 
#userdel... usermod for lock, modified
#/etc/passwd, /etc/group
##LDAP
#######################################
####MANAGING DISK & FILESYSTEMS
#fdisk, yo can view and change disk partitions
#mkfs, add filesystems to partition
#mount, and mount the filesystem: ext4 vfat 
#cockpit
#ls -l /dev show the disk device nodes 
#free -m
##SWAP
#mkswap enable swap temporarily
#####PARTITIONS
#parted -l /dev/sda to view disk partitions
#fdisk -l /dev/sdb USB
#blkid  shows info about partitions
#1)- Unmount the drive
#2)- fdisk for multiple or part for single partition
#3)- mkfs -t xfs /dev/sdb1 --make a filesystem(ext4..)
#4)- mkdir /mnt/test --create a mount point-- df   mount  to check
#5)-mount /dev/sdb2 /mnt/test -- to mount
#6)-umount /dev/sdb
#All partitions greater than four are logical partitions
#Back up partition table > sudo sgdisk -p /dev/sda
####FILESYSTEM
#lsattr  mkfs
#mount can be used to mount directories over network(samba)
#cat /proc/filesystems > list filesystems types available on distro
#Check file integrity
#rpm -V some_packet >>>Red hat
#df -h filesystem usage
#du -h disk usage
###Network shares (NFS) to mount remote filesystems through network
###Mounting:
#mount -a >> is executed in order to mount all filesystems listed in the
#cat /etc/fstab file >> contains definitions for each partition and devices
#blkid >> to see all UUIDs assignated to storage devices
#mkdir /mnt/kalel && mount -t ext3 -o ro /dev/sdb1 /mnt/tmp >>
#to mount a read only disk partition
#mount -t ext3 -o remount,rw /dev/sdb1 >> to change mounts options
#volume groups >> vgcreate vgextend vgreduce
####Mounting a disk in loopback
#useful for images which you want to install software without bourning
#mkdir /mnt/myimage && mount -o loop whatever.iso /mnt/myimage

