#!/bin/bash

# Find and display files with permissions set to 777
echo "Searching for files with permissions 777..."

# Use find command to locate files with permission 777
find . -type f -perm 0777 -print

# Check if any files were found
if [[ $? -eq 0 ]]; then
    echo "Search completed."
else
    echo "No files with permissions 777 found."
fi
