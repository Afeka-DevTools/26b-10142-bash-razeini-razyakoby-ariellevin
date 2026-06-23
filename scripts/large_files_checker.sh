#!/bin/bash

# Check if the required parameters were provided
if [ "$#" -ne 2 ]; then
    echo "Error: You must provide a directory path and a minimum size threshold."
    echo "Usage: $0 <directory_path> <+size>"
    echo "Example (files over 50MB): $0 /var/log +50M"
    exit 1
fi

TARGET_DIR=$1
SIZE_THRESHOLD=$2

# Check if the directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory does not exist: $TARGET_DIR"
    exit 1
fi

echo "Scanning for files larger than $SIZE_THRESHOLD inside $TARGET_DIR..."
echo "--------------------------------------------------------"
echo -e "File Size\tFull Path"
echo "--------------------------------------------------------"

# Find files and display their size in a human-readable format
find "$TARGET_DIR" -type f -size "$SIZE_THRESHOLD" -exec du -sh {} \;

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "Large file scan completed successfully!"
else
    echo "Error: File scan failed."
    exit 1
fi
