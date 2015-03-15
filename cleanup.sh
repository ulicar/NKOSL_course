#!/bin/bash

# Lazy unmount
file="test.txt"
dirs=($(echo ndir{1..2}))
label="nkosl_image"
 
for dir in ${dirs[@]}
do
        umount -l $fs $dir
        echo "Unmounted $dir $label to it."
	rm -Ri $dir
done

file_pid=$(ps uax | grep test.txt -m 1 | sed -r 's/\ +/ /' | cut -d' ' -f2
kill -9 $file_pid

rm -i $label

