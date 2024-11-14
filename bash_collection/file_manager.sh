#!/bin/bash

# Check if a directory argument is provided
if [ $# -ne 1 ]; then
  echo "Usage: $0 <directory>"
  exit 1
fi

DIRECTORY="$1"

# Check if the provided argument is a directory
if [ ! -d "$DIRECTORY" ]; then
  echo "Error: $DIRECTORY is not a valid directory."
  exit 1
fi

# Create subdirectories if they do not exist
mkdir -p "$DIRECTORY/Images" "$DIRECTORY/Documents" "$DIRECTORY/Music" "$DIRECTORY/Sh" 

# Move files to the corresponding subdirectories
mv "$DIRECTORY"/*.jpg "$DIRECTORY/Images/" 2>/dev/null
mv "$DIRECTORY"/*.txt "$DIRECTORY/Documents/" 2>/dev/null
mv "$DIRECTORY"/*.mp3 "$DIRECTORY/Music/" 2>/dev/null
mv "$DIRECTORY"/*.sh "$DIRECTORY/Sh" 2>/dev/null
echo "Files organized successfully."

