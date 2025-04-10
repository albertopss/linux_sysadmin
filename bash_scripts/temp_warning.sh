#!/bin/bash

# Threshold in millidegrees (80°C)
THRESHOLD=80000
LOGFILE="$HOME/temp_warnings.log"

while true; do
    TEMP=$(cat /sys/class/thermal/thermal_zone0/temp)

    if [ "$TEMP" -gt "$THRESHOLD" ]; then
        TEMP_C=$(echo "scale=1; $TEMP / 1000" | bc)
        echo "$(date '+%Y-%m-%d %H:%M:%S') ⚠️  WARNING: CPU temp above 80°C! Current: ${TEMP_C}°C" >> "$LOGFILE"
    fi

    sleep 10
done
