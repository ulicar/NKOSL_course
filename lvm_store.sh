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
dir_size=$(du -sk $DIR | sed -r 's/([0-9]+).*/\1/')
echo "Directory $DIR has a size of $dir_size KiB"


# Make a logical container
name="data"
container="pv_"$name
vg_name="vg_"$name
mount_point="/dev/loop0"

# Sigtly bigger container then max size
container_size=$(echo "26 * 1024 * 1024" | bc)

# count of $DIR parts, of size $msize
parts=$(echo "($dir_size) / $container_size + 1" | bc)

# Crate empty space
dd if=/dev/zero of=$container bs=$container_size count=$parts > /dev/null 


# Create loop setup
#losetup $mount_point $container 
#pvcreate $mount_point
#vgcreate $vg_name $mount_point


echo "Created $parts loopback devices with files:"
for part in $(eval echo {0..$parts})
do
    #device="disk.part"$part
    echo $part

    #lvcreate --name $device --size 25M $vg_name
    #echo "$device"
done

