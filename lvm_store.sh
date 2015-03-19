#!/bin/bash
source create_loop_device.sh


function f_calculate_dir_size {
  size=$(du -sk $1 | sed -r 's/([0-9]+).*/\1/')
		
  echo $size
}


function f_get_loop_device {
  loop=$(losetup -f 2>/dev/null)
  if [ -z $loop ] || [ ! -e $loop ]
  then
    create_loop_device >/dev/null || exit 3
    loop=$(losetup -f 2>/dev/null)
  fi
    
  echo $loop
}


function f_lvm_manage {
  pv_count=$1
  pv_size=$2
  device=$3

  if [ -z $pv_size ] || [ -z $pv_count ] || [ -z $device ] || [ $pv_count -gt 20 ] 
  then
    exit 5 # Tempororary block
  fi

  dd if=/dev/zero of=$device bs=4k count=6400 || exit 2
  lp=$(f_get_loop_device)

  losetup $lp $device >/dev/null || exit 2
  pvcreate $lp >/dev/null || exit 2
  vgcreate 'nkosl' $lp >/dev/null || exit 2 
 
  for (( id = 1; id <$((pv_count)); id++ ))
  do
    dd if=/dev/zero of=$device$id bs=4k count=6400 || exit 2
    lp=$(f_get_loop_device)

    losetup $lp $device$id >/dev/null 2>&1 || exit 3
    pvcreate $lp >/dev/null 2>&1 || exit 3
    vgextend 'nkosl' $lp >/dev/null 2>&1 || exit 3
  done

  mkdir -p /mnt/nkosl >/dev/null 2>&1 || exit 3
  lvcreate -l 100%VG nkosl -n new_fs >/dev/null 2>&1 || exit 3
  mkfs -t ext4 /dev/nkosl/new_fs >/dev/null 2>&1 || exit 3
  mount /dev/nkosl/new_fs /mnt/nkosl >/dev/null 2>&1 || exit 3

  echo "/mnt/nkosl"
}


function f_main {
  directory=$1
  dir_size=$(f_calculate_dir_size $directory)
  echo "Directory $directory has a size of $dir_size KiB"
   
  pv_size=$(echo "25 * 1024 *1024" | bc)
  pv_count=$(echo "($dir_size * 1024) / $pv_size + 1" | bc)
  device='new_disk.part'

  lv_name=$(f_lvm_manage $pv_count $pv_size $device)
  cp -R $directory $lv_name
    
  echo "Created $(echo "$pv_count +1" | bc) loopback devices with files"
  for id in $(eval echo {0..$pv_count})
  do        
    echo -e "\t$device$id"
  done
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



