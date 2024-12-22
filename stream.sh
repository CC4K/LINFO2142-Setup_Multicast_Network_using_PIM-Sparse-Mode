#!/bin/bash

# check if exactly two arguments are provided
if [[ $# -lt 1 ]]; then
    echo "Error: At least one argument is required"
    echo "Usage: ./stream.sh [SERVER_NAME]"
    echo "Type ./help.sh to see examples"
    exit 1
fi
# check if the first argument is a server (h1 or h4)
if [[ "$1" != "h1" && "$1" != "h4" ]]; then
    echo "Error: $1 is not a server"
    echo "Usage: ./stream.sh [SERVER_NAME]"
    echo "Type ./help.sh to see examples"
    exit 1
fi
server="$1"

# kill all instances of ffmpeg
sudo docker exec clab-igp-$server bash -c "pkill -f ffmpeg"

# launch stream on server
echo -e "The stream is starting on server $server..."
if [[ "$server" == "h4" ]]; then
    output=$(sudo docker exec clab-igp-h4 bash -c "ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff06::179]:50623?pkt_size=188" 2>&1)
    if echo "$output" | grep "Operation not permitted"; then
        echo "Server h4 is not allowed to stream"
    else
        echo "Error : Server h4 should not be allowed to stream !"
    fi
else
    echo "Server $server is now streaming !"
    sudo docker exec clab-igp-h1 bash -c "ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff06::179]:50623?pkt_size=188"
fi

exit 0
