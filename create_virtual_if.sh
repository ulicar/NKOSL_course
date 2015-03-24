#!/bin/bash

# Ubuntu network manager overwrites configuration
stop network-manager >/dev/null 2>&1 

# Create virual interface
device="eth0:0"
interface='/etc/network/interfaces'
touch $interface

cat >> $interface << EOF

# NKOSL virtual interface
auto $device
iface $device inet static
name eth0 Alias
address 172.16.92.64
netmask 255.255.255.192
network 172.16.0.0
gateway 172.16.92.120

EOF
echo "Placed virtual interface in $interface ..."

# Block incoming data, except IIRC
iptables-save > iptables.old
iptables -I INPUT 1 -i $device -p tcp --dport 6667 -j ACCEPT
#iptables -D INPUT 1
iptables -I INPUT 2 -i $device -j DROP
#iptables -D INPUT 1
echo 'Created entry in iptables ...'

# Start interface
ifup $device
echo 'Started virutal interface ...'

# Log created info
ifconfig      > ifconfig.log
route -n      > route.log 
iptables -nvL > iptables.log

