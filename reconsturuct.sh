#!/bin/bash

source create_loop_device.sh

N=4


umount /mnt/nkosl
lvremove /dev/nkosl/new_fs
vgremove nkosl
rmdir /dev/sending

for ((id=0; id <=$((N)); id++))
do
  losetup -d /dev/loop$id
done

for (( id=0; id <= $((N)); id++))
do
  create_loop_device >/dev/null || exit 3

  dev=/dev/loop$id
  file=new_disk.part$id
  losetup  $dev $file

done

pvcreate $(eval echo /dev/loop{0..$N})
vgcreate sending $(eval echo /dev/loop{0..$N})

mkdir /dev/sending -p
lvcreate -l 100%VG sending -n restored

mkdir /mnt/sending -p
fsck.ext4 /dev/sending/restored 
mount /dev/sending/restored /mnt/sending
ls /mnt/sending


