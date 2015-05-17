#!/bin/bash

FILENAME=ping.log
LOG_DIR=/var/log/nkosl/
LOG_FILE="$LOG_DIR""$FILENAME"

write_log(){
  time=$(date --rfc-3339=seconds)
  ping_reply=$(ping -c 1 8.8.8.8)
  echo "["$time"]"  $ping_reply
}

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

# Redirect all to $LOG
exec 2>&1 1>>$LOG_FILE

while sleep 10
do
  write_log
done

