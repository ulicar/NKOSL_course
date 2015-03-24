#/bin/bash

while true; do
  read -p "This is a destructive action. Cannot be reverted. Continue?" yn
  case $yn in
    [Yy]* ) echo 'Doing some work ...';break;;
    * ) exit;;
  esac
done

device=eth0:0

# Stop & Start
ifdown $device
start network-manager

# Delete created iptable entries -- check your config
iptables -D INPUT 1
iptables -D INPUT 1

# Delete ETH0:0 entry from /etc/network/interface
head -n -10 /etc/network/interfaces > /etc/network/interfaces  
