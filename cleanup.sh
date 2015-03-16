#!/bin/bash

vgremove "vg_data"

for i in {0..8}
do
    losetup -d /dev/loop$i
done
