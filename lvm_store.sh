#!/bin/bash
source create_loop_device

function f_calculate_dir_size {
    size=$(du -sk $1 | sed -r 's/([0-9]+).*/\1/')
		
		echo $size
}

function f_create_physical_volumens {
		pv_size=$(echo "25 * 1024 * 1024" | bc)
		echo "count is $pv_count, size is $pv_size"
    
		for id in $(eval echo {0..$pv_count})
    do  
				echo $device$id
        #dd if=/dev/zero of=$device$id bs=$pv_size count=1 || exit 2
    done
}

function f_get_loop_device {
    loop=$(losetup -f 2>/dev/null)
    if [ -z $loop ]
    then
        create_loop_device #>/dev/null || exit 3
        loop=$(losetup -f 2>/dev/null)
    fi
    
    echo $loop
}

function f_mount_physical_volumens {
		for id in $(eval echo {0..$pv_count})
    do
        mount_point=$(f_get_loop_device)
        losetup $mount_point $device$id #1> /dev/null || exit 4
        mounted_loop_devs=("${mounted_loop_devs[@]}" "$mount_point")       
    done

		echo $mounted_loop_devs
}

function f_notify {
		echo "Created $(eval echo $pv_count +1) loopback devices with files"
    for id in $(eval echo {0..$pv_count})
    do        
        echo -e "$device$id"
    done
}

function f_create_volume_group {
    vgcreate -s 1M $vg_name $mounted_loop_devices #1> /dev/null || exit -1 
}

function f_create_logical_volume {
    lvcreate -l 100%FREE -n $lv_name $vg_name #1> /dev/null || exit -1
}

function f_create_fs {
    mkfs -t ext4 $lv_name #1> /dev/null || exit -1
} 


function f_main {
    directory=$1
		dir_size=$(f_calculate_dir_size $directory)
    echo "Directory $directory has a size of $dir_size KiB"
   	
    pv_count=$(echo "($dir_size) / $pv_size + 1" | bc)
		device='new_disk.part'
    f_create_physical_volumens 

    declare -a mounted_loop_devs 
    #f_mount_physical_volumens
    f_notify
    
    vg_name='vg_nkosl'   
    #f_create_volume_group
    
    lv_name='nkosl'
    #f_create_lvgical_volume
    #f_create_ext4_fs
    
    #f_copy_dir_to_fs
    
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

f_main $1 



