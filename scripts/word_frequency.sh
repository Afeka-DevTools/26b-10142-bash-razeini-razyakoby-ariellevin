#!/bin/bash

# Check if the required parameters were provided
if [ "$#" -ne 1 ]; then
    echo "Error: You must provide a text file path to analyze."
    echo "Usage: $0 <file_path>"
    exit 1
fi

FILE_PATH=$1

# Check if the file exists and is a regular file
if [ ! -f "$FILE_PATH" ]; then
    echo "Error: The requested file does not exist or is invalid: $FILE_PATH"
    exit 1
fi

echo "Analyzing word frequency in file: $FILE_PATH..."
echo "Top 10 most common words in the file:"
echo "--------------------------------------------------------"

# Clean punctuation, convert to lowercase, split into words, sort, and count
tr '[:upper:]' '[:lower:]' < "$FILE_PATH" | tr -d '[:punct:]' | awk '{for(i=1;i<=NF;i++) print $i}' | sort | uniq -c | sort -rn | head -n 10

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------------"
    echo "File analysis and frequency display completed successfully!"
else
    echo "Error: File analysis failed."
    exit 1
fi
