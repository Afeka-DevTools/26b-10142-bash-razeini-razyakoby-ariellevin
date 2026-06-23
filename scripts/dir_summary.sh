#!/bin/bash

# Check if the required parameters were provided
if [ "$#" -ne 1 ]; then
    echo "Error: You must provide a directory path to analyze."
    echo "Usage: $0 <directory_path>"
    exit 1
fi

TARGET_DIR=$1

# Check if the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Target directory does not exist: $TARGET_DIR"
    exit 1
fi

echo "Analyzing and summarizing directory: $TARGET_DIR..."

# Count the types of resources in the current directory only
FILES_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type f | wc -l)
DIRS_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type d | wc -l)
LINKS_COUNT=$(find "$TARGET_DIR" -maxdepth 1 -type l | wc -l)

# Subtract the root directory itself which is counted automatically by find
DIRS_COUNT=$(( DIRS_COUNT - 1 ))

if [ $? -eq 0 ]; then
    echo "Analysis completed successfully!"
    echo "--------------------------------------"
    echo "📁 Sub-directories: $DIRS_COUNT"
    echo "📄 Regular files: $FILES_COUNT"
    echo "🔗 Symbolic links: $LINKS_COUNT"
    echo "--------------------------------------"
else
    echo "Error: Directory analysis failed."
    exit 1
fi
