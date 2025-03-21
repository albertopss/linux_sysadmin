#!/bin/bash

# Check if a file is provided and readable
if [ "$#" -ne 1 ] || [ ! -r "$1" ]; then
    echo "Error: You must provide a readable file as an argument."
    exit 1
fi

LOGFILE="$1"

# Temporary file to store the counts
TEMPFILE=$(mktemp)

# Extract failed login attempts and count them by IP address
grep 'Failed password' "$LOGFILE" | awk '{print $(NF)}' | sort | uniq -c | sort -nr > "$TEMPFILE"

# Output header for CSV
echo "Count,IP,Location"

# Read through the counted attempts and check for those with more than 10
while read -r count ip; do
    if [ "$count" -gt 10 ]; then
        # Get the location using geoiplookup
        location=$(geoiplookup "$ip" | awk -F: '{print $2}' | xargs)
        echo "$count,$ip,$location"
    fi
done < "$TEMPFILE"

# Clean up temporary file
rm "$TEMPFILE"

