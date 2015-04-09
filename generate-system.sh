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

mkdir /mnt/debian32
mkfs -t ext4 /dev/vg_debian/debian32_fs
mount /dev/vg_debian/debian32_fs /mnt/debian32



# Build a system
debootstrap --arch armel --foreign jessie /mnt/debian32 http://ftp.us.debian.org/debian
cp /usr/bin/qemu-arm-static /mnt/debian32/usr/bin/
chroot /mnt/debian32
/debootstrap/debootstrap --second-stage
apt-get clean
echo "deb http://ftp.us.debian.org/debian squeeze main" > /etc/apt/sources.list
exit


# Link the logging script into init.d directory
cp "$1" /etc/init.d/
ln -s /etc/init.d/"$1" /etc/rc0.d/K04"$1"



# Setup networking
stop network-manager >/dev/null 2>&1 

device="eth0:0"
interface='/etc/network/interfaces'
touch $interface
cat >> $interface << EOF
# NKOSL virtual interface
auto $device
iface $device inet static
name eth0 Alias
address 172.16.92.65
netmask 255.255.255.192
EOF

ip route add -net 172.16.0.0 netmask 255.255.0.0 gw 172.16.92.120

iptables -I INPUT 1 -i $device -p tcp --dport 6667 -j ACCEPT
iptables -I INPUT 2 -i $device -j DROP

iptables-save > /etc/iptables.rule

ifup $device



# Clean 
rm /mnt/debian32/usr/bin/qemu-arm-static
umount /mtn/debian32
losetup -d /dev/vg_debian/debian32_fs



