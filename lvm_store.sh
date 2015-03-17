#!/bin/bash
source create_loop_device

function f_calculate_dir_size {
    dir_size=$(du -sk $DIR | sed -r 's/([0-9]+).*/\1/')
    echo "Directory $DIR has a size of $dir_size KiB"
}

function f_create_physical_voluems {
    for id in $(eval echo {0..$pv_count})
    do        
        dd if=/dev/zero of=$device$id bs=$pv_size count=1 || exit 2
    done
    
    echo "Created $(eval echo $pv_count +1) devices"
    for id in $(eval echo {0..$pv_count})
    do        
        echo -e "$device$id"
    done
}


function f_main {
    f_calculate_dir_size
    
    name="data"
    container="pv_"$name
    vg_name="vg_"$name
    pv_size=$(echo "25 * 1024 * 1024" | bc)
    pv_count=$(echo "($dir_size) / $container_size + 1" | bc)
    device='disk.part'
    
    f_create_physical_volumens
    f_mount_physical_volumens
    f_create_volume_group
    f_create_fs
    f_copy_dir_to_fs


        device="disk.part"$id
        lvcreate --name $device --size $pv_size $vg_name 1> /dev/null || exit -1
        echo -e "\t $device"
    done
    
    # Create filesystem

    losetup $mount_point $container 1> /dev/null || exit -1
    pvcreate $mount_point 1> /dev/null || exit -1
    vgcreate -s 1M $vg_name $mount_point 1> /dev/null || exit -1 

    # Create partitions on a filesystem
    echo "Created $parts loopback devices with files:"

}

if [ "$(id -u)" != "0" ]
then
   echo "This script must be run as root" 1>&2
   exit 1
fi

if [ "$#" -ne 1 ] || [ ! -d $1 ] 
then
    echo "Usage: $0 sample-directory"
    exit 1
fi

DIR=$1
f_main 



