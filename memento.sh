#/bin/bash

# Sha-bang in perl
#!/usr/bin/perl

# find a location of some executable, eg. grep
whereis grep

# determen hardware of your machine
lscpi

# Find all of the processes started by a USER and kill them 
# ps -o pid= -u $USER | xargs kill
# killall $USER
# pkill -u $USER

# List all open files, by users $USER1 and $USER2
lsof -u $USER1,$USER2

# Backup files, without tars
# rsync -avz --exclude '*.tar' source/ destination/

# report back how many tcp connections are in `LISTEN` state
nestat --tcp --listen | wc -l

# Find mail exchange of a site
dig $SITE mx

# Find iptables records with line numbers
iptables -L --line-numbers

# Drop rule 10 in iptables
ipdables -D CHAINNAME 10

# Block IP
iptables -A INPUT -s $IPADDRESS -j DROP

# Change machines' DNS to 8.8.8.8
# echo 'nameserver 8.8.8.8' > /etc/resolv.conf

# Schedule restart at 2am
# shutdown -r 02:00 'Shutting down at 2am'

# Get a status from a service
service $NAME status

# TODO:
#reate a one-liner that does the following task.  
#  A) Generate a report of all IP addresses that appear in access log file from today.  
#  B) Count the number of times an IP appears in the report.  
#  C) Determine what is the 5th most active IP address, 
#  D) Return the second set of 3 digits.  ie. ***.168.***.***


