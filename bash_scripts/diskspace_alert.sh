#!/bin/sh
# set -x
# Shell script to monitor or watch the disk space
# It will redirect to a FIFO file if percentage of space is >= 10% for testing
# --------------------------------------------------------------------------------------------------------

LOG_FILE="/phat/to/fifo_file.txt"
DATE=$(date "+%Y-%m-%d %H:%M:%S")
#
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#he pattern /[0-9]+%/ ensures that we are selecting lines where $5 contains numbers followed by % (to avoid headers).
df -h | awk '$5 ~ /[0-9]+%/ {gsub("%", "", $5); if ($5 >= 10) print $0}' > /tmp/disk_alert.tmp

# If any partition is above 10%, log it this is for testing change it
if [[ -s /tmp/disk_alert.tmp ]] 
then
    echo "[$DATE] ALERT: High disk usage detected! on server $(hostname)" >> $LOG_FILE
    cat /tmp/disk_alert.tmp >> $LOG_FILE
    echo "----------------------------" >> $LOG_FILE
fi

# Cleanup temporary file
rm -f /tmp/disk_alert.tmp

