# mkfs dd mount

Needs superuser privileges
   Usage: sudo su -c "./local_fs.sh"
	
   Use cleanup.sh afterwards

1) Creates 32MB empty file  
2) Creates a ext4 filesystem from a empty file  
3) Change the FS label  
4) Make 2 directories and mount filesystem to it  
5) Create file in FS  
6) Open some background process on file  
7) Try to unmount of FS. !!! Fails due to open process !!!  

