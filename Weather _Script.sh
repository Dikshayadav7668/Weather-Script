#!/bin/bash

# Function to display usage instructions
usage() {
    echo "Usage: $0 [options] <location>"
    echo "Options:"
    echo "  -f, --forecast               Get weather forecast"
    echo "  -u, --units <unit>           Specify units (metric/imperial)"
    echo "  -p, --provider <provider>    Specify weather provider (wttr.in/openweathermap)"
    echo "  -h, --help                   Show usage instructions"
}

# Default values
forecast=false
units="metric"
provider="wttr.in"

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -f|--forecast) forecast=true ;;
        -u|--units) units="$2"; shift ;;
        -p|--provider) provider="$2"; shift ;;
        -h|--help) usage; exit 0 ;;
        *) location="$1" ;;
    esac
    shift
done

# Check if location is provided
if [ -z "$location" ]; then
    echo "Error: Please provide a location."
    usage
    exit 1
fi

# Function to get current weather
get_current_weather() {
    local location="$1"
    local units="$2"
    local provider="$3"
    
    local weather_data
    weather_data=$(curl -s "${provider}/${location}?format=1&${units}")
    echo "$weather_data"
}

# Function to get weather forecast
get_weather_forecast() {
    local location="$1"
    local units="$2"
    local provider="$3"
    
    local weather_data
    weather_data=$(curl -s "${provider}/${location}?format=3&${units}")
    echo "$weather_data"
}

# Check if forecast is requested
if [ "$forecast" = true ]; then
    weather_info=$(get_weather_forecast "$location" "$units" "$provider")
else
    weather_info=$(get_current_weather "$location" "$units" "$provider")
fi

# Display weather information
echo "$weather_info"
