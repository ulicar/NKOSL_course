#!/bin/bash

# Creates Debian 32bit testing system. 
# 
# Uses Deboostrap.
# 1st argument: Script to be executed upon shutdown (logging script)


# Create a disk image
fallocate -l 1G debian32.img
losetup /dev/loop1 debian32.img
pvcreate /dev/loop1
vgcreate 'vg_debian32' /dev/loop1
lvcreate -l 100%VG "vg_debian32" -n "debian32_fs"

mkdir /mnt/debian32
mkfs -t ext4 /dev/vg_debian/debian32_fs
mount /dev/vg_debian/debian32_fs /mnt/debian32










