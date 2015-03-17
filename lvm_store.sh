#!/bin/bash

function calculate_dir_size {
    dir_size=$(du -sk $DIR | sed -r 's/([0-9]+).*/\1/')
    echo "Directory $DIR has a size of $dir_size KiB"
}

function create_lvm_names {
    name="data"
    container="pv_"$name
    vg_name="vg_"$name
    mount_point=$(losetup -f)
}

function initialize_lvm {
    container_size=$(echo "26 * 1024 * 1024" | bc)
    parts=$(echo "($dir_size) / $container_size + 1" | bc)

    # Create filesystem
    dd if=/dev/zero of=$container bs=$container_size count=$parts 2> /dev/null 

    losetup $mount_point $container 1> /dev/null || exit -1
    pvcreate $mount_point 1> /dev/null || exit -1
    vgcreate -s 1M $vg_name $mount_point 1> /dev/null || exit -1 

    # Create partitions on a filesystem
    echo "Created $parts loopback devices with files:"
    count=$(echo "$parts - 1" | bc)
    for part in $(eval echo {0..$count})
    do
        device="disk.part"$part
        lvcreate --name $device --size 25M $vg_name 1> /dev/null || exit -1
        echo -e "\t $device"
    done

}

DIR=$1
if [ "$#" -ne 1 ] || [ ! -d $DIR ] 
then
    echo "Usage: $0 sample-directory"
    exit -1
fi

calculate_dir_size 

create_lvm_names 

initialize_lvm 



