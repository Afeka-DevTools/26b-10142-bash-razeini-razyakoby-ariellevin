#!/bin/bash

# Check if the required parameters were provided
if [ "$#" -ne 1 ]; then
    echo "Error: You must provide a process name to kill."
    echo "Usage: $0 <process_name>"
    exit 1
fi

PROCESS_NAME=$1

# Check if the process is currently running
if ! pgrep -x "$PROCESS_NAME" > /dev/null; then
    echo "Error: No active processes found running under the name: $PROCESS_NAME"
    exit 1
fi

echo "Terminating all processes named $PROCESS_NAME..."
pkill -x "$PROCESS_NAME"

if [ $? -eq 0 ]; then
    echo "Operation completed successfully! All processes have been closed."
else
    echo "Error: Failed to kill processes (sudo permissions may be required)."
    exit 1
fi
