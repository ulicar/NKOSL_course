#!/bin/bash

# Destroys /dev/loopX devices, that are NOT in use.

# TODO: see why loop_device=$(losetup -f) in a while-loop doesn' work

function destroy_loop_devices {
    device='/dev/loop'
    count=$(ls /dev | tac | grep -E loop[0-9]+ | cut -d'p' -f2 | sort -rn | head -n 1)
    for id in $(eval echo {0..$count}) 
    do
        losetup -d $device$id 2>/dev/null || (rm $device$id && echo "Deleted $device$id")
    done
}


if [[ $_ = $0 ]]
then
    destroy_loop_devices
fi

