#!/bin/bash

source destroy_loop_devices.sh

umount /mnt/sending
umount /mnt/nkosl

lvremove /dev/nkosl/new_fs
lvremove /dev/sending/restored

vgremove nkosl
vgremove sending

for i in {0..20}
do
    losetup -d /dev/loop$i
done

destroy_loop_devices

rmdir /mnt/nkosl /dev/sending /mnt/sending /dev/nkosl
rm new_disk*
