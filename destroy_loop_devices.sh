#!/bin/bash

# Destroys /dev/loopX devices, that are NOT in use.

function destroy_loop_devices {
    loop_device=$(losetup -f)
    while [ -n $loop_device ]
    do
        losetup -d $loop_device
    done
}


if [[ $_ = $0 ]]
then
    destroy_loop_devices
fi

