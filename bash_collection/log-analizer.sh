#!/bin/bash

# Check if the log file exists
LOG_FILE="server.log"
if [[ ! -f $LOG_FILE ]]; then
    echo "Log file not found!"
    exit 1
fi

# Initialize counters
total_entries=0
info_count=0
warn_count=0
error_count=0
declare -A error_messages

# Read the log file
while IFS= read -r line; do
    ((total_entries++))
    
    # Extract the log level and message
    log_level=$(echo "$line" | awk '{print $3}')
    message=$(echo "$line" | cut -d' ' -f4-)

    case $log_level in
        INFO)
            ((info_count++))
            ;;
        WARN)
            ((warn_count++))
            ;;
        ERROR)
            ((error_count++))
            error_messages["$message"]=1
            ;;
    esac
done < "$LOG_FILE"

# Generate the summary report
echo "Total log entries: $total_entries"
echo "INFO count: $info_count"
echo "WARN count: $warn_count"
echo "ERROR count: $error_count"
echo "Unique ERROR messages:"

for error in "${!error_messages[@]}"; do
    echo " - $error"
done
