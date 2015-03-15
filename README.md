# Working with LVM (logical volume manager)


Bash script that creates ext4 filesystem used with LMV to create files upto 25MB (so they be sent via mail service)

Usage:
&nbsp;&nbsp;./lvm-store.sh sample_dir  
&nbsp;&nbsp;&nbsp;&nbsp;Directory sample_dir has a size of 25 MiB.  
&nbsp;&nbsp;&nbsp;&nbsp;Made 2 loopback devices, with files:  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;disk0.vol  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;disk1.vol   

