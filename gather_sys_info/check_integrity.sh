#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check integrity of system
check_integrity() {
    echo "System Integrity Check Report"
    echo "-----------------------------"
    
    # Check if system is up-to-date
    if command_exists "apt-get"; then
        echo "System package updates:"
        apt-get update >/dev/null
        apt-get --just-print upgrade | grep -v 'upgraded, 0 newly installed' || echo "System is up-to-date."
        echo
    elif command_exists "yum"; then
        echo "System package updates:"
        yum check-update | grep -v 'Updated Packages' || echo "System is up-to-date."
        echo
    fi
    
    # Check for modified files in important directories
    echo "Modified files in critical directories (/bin, /sbin, /usr/bin, /usr/sbin):"
    find /bin /sbin /usr/bin /usr/sbin -type f -exec stat --format="%n %Y" {} + | awk '$2 != "0"' || echo "No modified files found."
    echo
    
    # Check for unexpected setuid/setgid files
    echo "Unexpected setuid/setgid files:"
    find / -type f \( -perm -4000 -o -perm -2000 \) -exec ls -l {} + | grep -v '/proc/' || echo "No unexpected setuid/setgid files found."
    echo
    
    # Check for world-writable files
    echo "World-writable files:"
    find / -type f -perm -o+w -exec ls -l {} + | grep -v '/proc/' || echo "No world-writable files found."
    echo
    
    # Check for root-owned files in home directories
    echo "Root-owned files in home directories:"
    find /home -type f -user root -exec ls -l {} + | grep -v '/proc/' || echo "No root-owned files found in home directories."
    echo
    
    # Check for unauthorized users
    echo "Unauthorized users:"
    awk -F: '($3 < 1000) {print $1}' /etc/passwd || echo "No unauthorized users found."
    echo
    
    # Check for unauthorized sudoers
    echo "Unauthorized sudoers:"
    sudo grep -v '^#' /etc/sudoers | grep -v '^$' || echo "No unauthorized sudoers found."
    echo
}

# Run the integrity check function
check_integrity

exit 0
