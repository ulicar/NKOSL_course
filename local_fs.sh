#!/bin/bash

# Needs superuser privileges
# Usage: sudo su -c "./local_fs.sh"

# Creates a ext4 filesystem, of a 32MB file.
# Mounts that filesystem (with new label) on 2 directories.


# 1
fs_name="my_ext4_fs"
size=$(echo "32*1024*1024" |bc)
dd if=/dev/zero of=$fs_name bs=$size count=1 &>/dev/null
echo "32MB file created ..."


# 2
mkfs -V -t ext4 $fs_name &>/dev/null
echo "Ext4 created from empty file."


# 3 
label="nkosl_image"
tune2fs -L $label $fs_name &>/dev/null
echo "Change the label to $label"


# 4
dirs=($(echo ndir{1..2}))
for dir in ${dirs[@]}
do
	mkdir -p $dir
	name=$(echo $(pwd)/$fs_name)
	mount $name $dir &>dev/null
	echo "Created $dir and mounted $label to it."
done

# 5 
file="test.txt"
cd ${dirs[0]}
touch $file
echo "Created file in $(pwd)"


# 6 
tail -f $file &


# 7
cd ..
for dir in ${dirs[@]}
do
        umount $fs $dir
        echo "Unmounted $dir $label to it."
done

