#/bin/bash

for i in {0..7}
do 
    sudo mknod -m640 /dev/loop$i b 7 $i
    sudo chown root:disk /dev/loop$i

done

