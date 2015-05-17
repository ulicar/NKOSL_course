#!/bin/bash

FILENAME=tcpdump.log
LOG_DIR=/var/log/nkosl/
LOG_FILE="$LOG_DIR""$FILENAME"

if [ "$(id -u)" != "0" ]; then
    echo "Start as root" && exit -1
fi

if [ ! -d "$LOG_DIR" ]
then
  echo "Creating log dir $LOG_DIR"
  mkdir -r "$LOG_DIR"
fi

if [ ! -f "$LOG_FILE" ]; then
  echo Creating log file "$LOG_FILE" .
  touch $LOG_FILE
fi

# redirect output
exec 2>&1 1>>$LOG_FILE

# track only ICMP messages to google DNS 8.8.8.8
tcpdump -lnv -i eth0 icmp and dst host 8.8.8.8 

