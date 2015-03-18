#!/bin/bash
source create_loop_device.sh

function f_calculate_dir_size {
  size=$(du -sk $1 | sed -r 's/([0-9]+).*/\1/')
		
  echo $size
}

function f_create_physical_volumens {
  pv_count=$1
  pv_size=$2
  if [ -z $pv_size ] || [ -z $pv_count ] || [ $pv_count -gt 10 ] 
  then
    exit 5 # Tempororary block
  fi

  echo "count is $pv_count, size is $pv_size"
  #dd if=/dev/zero of=$device bs=$pv_size count=1 || exit 2
	
  for id in $(eval echo {0..$pv_count})
  do  
	  cp $device $device$id
  done
	
  rm $device
}

function f_get_loop_device {
  loop=$(losetup -f)
  if [ -z $loop ]
  then
    create_loop_device >/dev/null || exit 3
    loop=$(losetup -f 2>/dev/null)
  fi
    
  echo $loop
}

function f_mount_physical_volumens {
  mounted=()
  for id in $(eval echo {0..$1})
  do
    create_loop_device >/dev/null && mount_point=$(losetup -f) || exit 4
    losetup $mount_point $2$id 1> /dev/null || exit 4

    mounted+=($mount_point)      
  done

  echo "${mounted[@]}"	
}

function f_notify {
  echo "Created $(echo "$1 +1" | bc) loopback devices with files"
  for id in $(eval echo {0..$1})
  do        
    echo -e "\t$2$id"
  done
}

function f_create_volume_group {
  vg_name='vg_nkosl'   
  #vgcreate -s 1M $vg_name $@ #1> /dev/null || exit -1 
	
  echo $vg_name
}

function f_create_logical_volume {
  lv_name='nkosl'
  #lvcreate -l 100%FREE -n $lv_name $1 #1> /dev/null || exit -1

  echo $lv_name
}

function f_create_fs {
  echo $1
  #mkfs -t ext4 $1 #1> /dev/null || exit -1
} 

function f_copy_dir_to_fs {
  echo "copy $1 to $2 "
  #cp -R $1 $2
}

function f_main {
  directory=$1
  dir_size=$(f_calculate_dir_size $directory)
  echo "Directory $directory has a size of $dir_size KiB"
   
  pv_size=$(echo "25 * 1024 * 1024" | bc)
  pv_count=$(echo "($dir_size) / $pv_size + 1" | bc)
  device='new_disk.part'
  f_create_physical_volumens $pv_count $pv_size

  mounted=($(f_mount_physical_volumens $pv_count $device))
  f_notify $pv_count $device
  echo ${mounted[@]}
  vg_name=$(f_create_volume_group ${mounted[@]})
  echo $vg_name	
  lv_name=$(f_create_logical_volume $vg_name)
   
  f_create_fs $lv_name
    
  f_copy_dir_to_fs $directory $lv_name
    
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



