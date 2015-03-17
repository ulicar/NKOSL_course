#/bin/bash

# Needs superuser
function create_loop_device {
    curr_loop_number=$(ls /dev | tac | grep -E loop[0-9]+ | cut -d'p' -f2 | sort -rn | head -n 1)
    if [ -z $curr_loop_number ]
    then
        $curr_loop_number=-1
    fi
    
    next_loop_number=$(echo "$curr_loop_number + 1" | bc)
    
    mknod -m640 /dev/loop$next_loop_number b 7 $next_loop_number || exit 2
    chown root:disk /dev/loop$next_loop_number || exit 2
    echo "Created /dev/loop$next_loop_number "
}

if [[ $_ = $0 ]]
then
    create_loop_device
fi
