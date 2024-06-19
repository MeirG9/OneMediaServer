#!/bin/bash

# Function to check Sonarr queue
check_sonarr_queue() {
    # Make API call and store response
    sonarr=$(curl -s -X 'GET' \
        'http://10.27.27.114:8989/api/v3/queue/status?apikey=<your_API>' \
        -H 'accept: application/json' \
        -H 'X-Api-Key: <your_API>')

    # Parse totalRecords from JSON response
    stotalCount=$(echo $sonarr | jq '.totalCount')

    # Check if totalRecords is 0
if [ "$stotalCount" -eq 0 ]; then
        return 0 # Queue is empty
    else
        return 1 # Queue is not empty
    fi
}

# Function to check Radarr queue
check_radarr_queue() {
    # Make API call and store response
    radarr=$(curl -s -X 'GET' \
        'http://10.27.27.114:7878/api/v3/queue/status?apikey=<your_API>' \
        -H 'accept: application/json' \
        -H 'X-Api-Key: <your_API>')

    # Parse totalRecords from JSON response
    rtotalCount=$(echo $radarr | jq '.totalCount')

    # Check if totalRecords is 0
if [ "$rtotalCount" -eq 0 ]; then
        return 0 # Queue is empty
    else
        return 1 # Queue is not empty
    fi

}

# Function to check Tautulli
check_tautulli_queue() {
    # Make API call and store response
    tautulli=$(curl -s -X 'GET' \
        'http://10.27.27.114:8181/api/v2?apikey=<your_API>&cmd=get_activity' \
        -H 'accept: application/json' \
        -H 'X-Api-Key: <your_API>')

# Parse stream_count from JSON response
    ttotalCount=$(echo $tautulli | jq '.response.data.stream_count')
    # Check if stream_count is 0, empty, or null
    if [ "$ttotalCount" == "\"0\"" ] || [ -z "$ttotalCount" ] || [ "$ttotalCount" == "null" ]; then
        return 0 # Queue is empty
    else
        return 1 # Queue is not empty
    fi
}

# Function to check all
check_all_queue() {
if check_sonarr_queue && check_radarr_queue && check_tautulli_queue; then
        return 0 # Queue is empty
   else
        return 1 # Queue is not empty
   fi
}

# Main script logic
if check_all_queue; then
    echo "Queues are empty. Rebooting..."
else
    echo "There are items in the queue. No reboot."
fi

