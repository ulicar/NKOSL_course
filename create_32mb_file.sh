#!/bin/bash

size=$(echo '32 * 1024 * 1024' | bc)

dd if=/dev/zero of=new_file bs=$size count=1

