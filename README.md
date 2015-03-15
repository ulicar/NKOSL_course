# Working with LVM (logical volume manager)


Bash script that creates ext4 filesystem used with LMV to create files upto 25MB (so they be sent via mail service)

Usage:
	./lvm-store.sh sample_dir
	    Directory sample_dir has a size of 25 MiB.
	    Made 2 loopback devices, with files:
	         disk0.vol
		 disk1.vol 

