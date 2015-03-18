#!/bin/bash

vgremove "vg_nkosl"

  for i in {0..20}
do
    losetup -d /dev/loop$i
done
