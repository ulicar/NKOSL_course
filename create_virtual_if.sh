#!/bin/bash

# Create virual interface
device="enp4s0_1"
interface='/etc/sysconfig/network-scripts/ifcfg-'$device
touch $interface

cat >> $interface << EOF
# NKOSL virtual interface
HWADDR=54:BE:F7:72:32:83
TYPE=Ethernet
BOOTPROTO=none
IPADDR=172.16.92.64
PREFIX=26
GATEWAY=172.16.92.120
DNS1=8.8.8.8
DEFROUTE=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=enp4s0_1
UUID=5b0219cf-87e2-4d5f-982f-586448500324
ONBOOT=yes

EOF


# Block incoming data, except IIRC
iptables-save > iptables.old
iptables -I INPUT 7 -i $device -p tcp --dport 6667 -j ACCEPT
iptables -I INPUT 8 -i $device -p all -j DROP

# Create Routes
ip route add 172.16.0.0/26 via 172.16.92.120

# Start interface
nmcli connection up enp4s0_1

# Log created info
ifconfig      > ifconfig.log
route -n      > route.log 
iptables -nvL > ipdables.log

