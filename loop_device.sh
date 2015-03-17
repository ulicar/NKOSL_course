#/bin/bash

# Needs superuser
function create_loop_device {
    next_loop_number=$(ls /dev | tac | grep -E loop[0-9]+ -m1 | sed 's/loop//')
    if [ -z $next_loop_number ]
    do
        $next_loop_number=0 
    done

    mknod -m640 /dev/loop$next_loop_number b 7 $next_loop_number || exit 2
    chown root:disk /dev/loop$next_loop_number || exit 2
}

create_loop_device()
