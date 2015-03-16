#!/bin/bash

DIR=$1
if [ "$#" -ne 1 ] 
then
    echo "Usage: $0 sample-directory"
    exit -1
fi

if [ ! -d $DIR ]
then
    echo "Directory $DIR must exit!"
    exit -1
fi

# Check direcotry size
size=$(du -sk test_dir | sed -r 's/([0-9]+).*/\1/')
echo "Directory $DIR has a size of $size kb"


# Make a logical container
$container="lvm_container"
$vg_name="vg_"$container
$mount_point="tmp_filesystem"

# max filesizes 25MB
msize=$(echo "25 * 1024 * 1024" | bc)
# size of a appropriate containter
csize=$(echo "($size * 1024) / $msize + 1" | bc)
# Crate empty space
dd if=/dev/zero of=$container bs=$msize count=$csize > /dev/null 
# Create loop setup
losetup /dev/loop0 $container 
# Crete filesistem
mkfs -t ext4 /dev/loop0 
# Mount tmp filesystem
mount /dev/loop0 $mount_point

# create N containers
pvcreate $mount_point
vgcreate $vgname
# lvcreate -l 100%FREE -n lvn0 $vgname



