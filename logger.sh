#!/bin/bash

# Loggin script for debian testing system
# Needs root privileges
#if [ -u 0 ]: then
#  echo 'Start as root' && exit -1
#fi

LOGD=/var/log/nkosl
LOG="$LOGD""/shutdown.log" 

if [ ! -d "$LOGD" ]; then
  echo Creating log dir "LOGD"
  mkdir -r "$LOGD"
fi

if [ ! -f "$LOG" ]; then
  echo Creating log file "$LOG" .
  touch $LOG
fi

# Redirect all STDOUT to $LOG
exec 6>&1       # Save STDOUT descriptor as #6
exec > $LOG     # Redirect STOUT to LOG

# Info
INFO="[INFO $(date)] "

# Kernel version
echo $INFO Kernel version: $(uname -r)

# Kernel modules, with paths
LOADED_MODULES=$(cat /proc/modules | cut -d' ' -f1)
for module in $LOADED_MODULES; do 
  path=$(modinfo -n $module);
  echo $module $path;
done


# Network config, CIDR
config=$(ip -o addr show | awk '{print $2, $4}')
echo $INFO "Network: "
echo $config


# Iptables
iptables -vnL


# Restore regular STDOUT
exec 1>&6 6>&-
echo Saved && exit 0
