#!/bin/bash

source destroy_loop_devices.sh

umount /dev/nkosl/new_fs
lvremove /dev/nkosl/new_fs
vgremove "vg_nkosl"

for i in {0..20}
do
    losetup -d /dev/loop$i
done

destroy_loop_devices

rmdir /mnt/nkosl
rm new_disk*
