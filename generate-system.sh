#!/bin/bash

# Creates Debian 32bit testing system. 
# 
# WARNING!!! 
# Requirements: debootstrap, qemu-user-static, binfmt-support
# 1st argument: Script to be executed upon shutdown (logging script)

if [ "$(id -u)" != "0" ]
then
    echo "This script must be run as root" && exit 1
fi

if [ "$#" -ne 1 ] || [ ! -f $1 ] 
then
  echo "Usage: $0 path/to/logging-script.sh"
  exit 1
fi


# Create an empty file image (refer to branch LAB1 or google "Logical Volume Manager")
fallocate -l 1G debian32.img
losetup /dev/loop1 debian32.img
pvcreate /dev/loop1
vgcreate 'vg_debian32' /dev/loop1
lvcreate -l 100%VG "vg_debian32" -n "debian32_fs"

DEBIAN=/mnt/debian32/
mkdir $DEBIAN
mkfs -t ext4 /dev/vg_debian/debian32_fs
mount /dev/vg_debian/debian32_fs $DEBIAN

# Build a basic system
debootstrap --arch amd64 --foreign  wheezy $DEBIAN http://ftp.us.debian.org/debian

# Link the logging script into init.d directory
cp "$1" $DEBIAN/etc/init.d/
mkdir -p $DEBIAN/etc/rc0.d/
ln -s $DEBIAN/etc/init.d/"$1" $DEBIAN/etc/rc0.d/K04"$1"

# Setup networking
device="eth0:0"
interface=$DEBIAN'/etc/network/interfaces'
touch $interface
cat >> $interface << EOF
# NKOSL virtual interface
auto eth0:0
iface eth0:0 inet static
name eth0 Alias
address 172.16.92.65
netmask 255.255.255.192
network 172.16.92.64
up route add -net 172.16.0.0 netmask 255.255.0.0 gw 172.16.92.120 dev eth0:0
EOF

cat >> $iptables << EOF
Chain INPUT (policy DROP 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination         
     0     0 ACCEPT     tcp  --  eth0:0 *       0.0.0.0/0            0.0.0.0/0            tcp dpt:6667

Chain FORWARD (policy DROP 0 packets, 0 bytes)
pkts bytes target     prot opt in     out     source               destination 

Chain OUTPUT (policy ACCEPT 0 packets, 0 bytes)
 pkts bytes target     prot opt in     out     source               destination
EOF

# Clean 
umount /mnt/debian32
losetup -d /dev/vg_debian/debian32_fs
