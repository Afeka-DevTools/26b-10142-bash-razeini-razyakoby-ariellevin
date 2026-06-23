#!/bin/bash

# Check if the required parameters were provided
if [ "$#" -ne 1 ]; then
    echo "Error: You must provide a city name in English."
    echo "Usage: $0 <city_name>"
    exit 1
fi

CITY=$1

# Check if curl is installed (required for the API request)
if ! command -v curl &> /dev/null; then
    echo "Error: curl is not installed and is required to run this script."
    exit 1
fi

echo "Fetching current weather data for $CITY..."
curl -s "https://wttr.in/${CITY}?m"

if [ $? -eq 0 ]; then
    echo "--------------------------------------------------"
    echo "Weather data fetched successfully!"
else
    echo "Error: Failed to fetch weather data."
    exit 1
fi
