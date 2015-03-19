# Working with LVM (logical volume manager)

Bash script that creates ext4 filesystem (utilises LMV) of a files (physical volumes) upto 25MB (so they be sent via mail service).

Warning: Don't user this on older kernels that use 'modeprobe loop' way of creating loop devices.

Info: http://linuxconfig.org/linux-lvm-logical-volume-manager 


Problem>
Mails often have a limit of 25MB per file. How to send a larger file/directory?

Solution>
(Among many others :) )
Create a filesystem for that file/directory (with <25MB physical volumens) and reconstruct it on the ther side. (Physical volumens in LVM work like RAID0)


Usage:
&nbsp;&nbsp;./lvm-store.sh sample_dir  
&nbsp;&nbsp;Directory sample_dir has a size of 25 MiB.  
&nbsp;&nbsp;Created 2 loopback devices, with files:                             
&nbsp;&nbsp;&nbsp;&nbsp;disk0.vol  
&nbsp;&nbsp;&nbsp;&nbsp;disk1.vol   

