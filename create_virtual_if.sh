#!/bin/bash

# Create virual interface
device="etho0:0"
interface='/etc/network/interfaces'
touch $interface

cat >> $interface << EOFi
# NKOSL virtual interface
auto $device
iface $device inet static
name Ethernet alias LAN card
address 172.16.92.64
netmask 255.255.255.192
network 172.16.0.0
gateway 172.16.92.120

EOF

# Block incoming data, except IIRC
iptables -A INPUT -i $device -p tcp --dport 6667 -j ACCEPT


# Start interface
ifup $device


# Log created info
ifconfig      > ifconfig.log
route -n      > route.log 
iptables -nvL > ipdables.log

