#!/bin/bash

# Creates image Debian 32bit testing system. 
# 
# WARNING!!! 
# Requirements: debootstrap
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

DEBIAN=/debian32/
mkdir $DEBIAN
# Deboostrab Debian64bit TESTING system
debootstrap --arch amd64 \ 
            --foreign  jessie \ 
            $DEBIAN http://ftp.us.debian.org/debian || exit -1


# Link the logging script into init.d directory, start on reboot (rc6)
mkdir -p $DEBIAN/etc/rc6.d/
cp "$1" $DEBIAN/etc/init.d/
ln -s $DEBIAN/etc/init.d/"$1" $DEBIAN/etc/rc6.d/K04"$1"


# Setup networking and iptables
interface=$DEBIAN'/etc/network/interfaces'
touch $interface
cat >> $interface << EOF
auto eth0:0
 iface eth0:0 inet static
 name eth0 Alias
 address 172.16.92.65
 netmask 255.255.255.192
 network 172.16.92.64
 up route add -net 172.16.0.0 netmask 255.255.0.0 gw 172.16.92.120 dev eth0:0
EOF

iptables=$DEBIAN'/etc/iptables.rules'
touch $iptables
cat > $iptables << EOF
*filter
:INPUT DROP [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A INPUT -i eth0:0 -p tcp -m tcp --dport 6667 -j ACCEPT
COMMIT
EOF


# Make a Debian32 Testing image
fallocate -l 1G debian32.img
losetup /dev/loop1 debian32.img
pvcreate /dev/loop1
vgcreate 'vg_debian32' /dev/loop1
lvcreate -l 100%VG "vg_debian32" -n "debian32_fs"

mkfs -t ext4 /dev/vg_debian/debian32_fs
mount /dev/vg_debian/debian32_fs /mnt/debian32
mv -r $DEBIAN /mnt/debian32

# Clean 
umount /mnt/debian32
losetup -d /dev/loop1
