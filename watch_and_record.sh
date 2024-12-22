#!/bin/bash

# check if exactly two arguments are provided
if [[ $# -lt 1 ]]; then
    echo "Error: At least one argument is required"
    echo "Usage: ./watch_and_record.sh [CLIENT_NAME] [DURATION (optional and > 5 seconds)]"
    echo "Type ./help.sh to see examples"
    exit 1
fi
# check if the first argument is a client (h2 or h3)
if [[ "$1" != "h2" && "$1" != "h3" ]]; then
    echo "Error: $1 is not a client"
    echo "Usage: ./watch_and_record.sh [CLIENT_NAME] [DURATION (optional and > 5 seconds)]"
    echo "Type ./help.sh to see examples"
    exit 1
fi
client="$1"
if [[ $# -eq 2 ]]; then
    # Check if the second argument is a number > 5
    if ! [[ "$2" =~ ^[0-9]+$ ]] || [[ "$2" -le 5 ]]; then
        echo "Error: Second optional argument must be a duration > 5"
        echo "Usage: ./watch_and_record.sh [CLIENT_NAME] [DURATION (optional and > 5 seconds)]"
        echo "Type ./help.sh to see examples"
        exit 1
    fi
    N="$2"
else
    N=15
fi
server="h1"

# delete preexisting video files from client
if [[ "$client" == "h2" ]]; then
    sudo rm output_$server-h2.mp4 2> /dev/null
fi
if [[ "$client" == "h3" ]]; then
    sudo rm output_$server-h3.mp4 2> /dev/null
fi
sudo docker exec clab-igp-$client bash -c "rm *.mp4" 2> /dev/null

# subscribe to stream and record on client
echo -e "Client $client is subscribing to the stream..."
sudo docker exec -d clab-igp-$client bash -c "ffmpeg -i udp://@[ff06::179]:50623 -c copy output_$server-$client.mp4"
echo -e "Client $client is watching the stream"

# watching stream for N seconds
echo -n "Recording the stream"
for i in $(seq 1 $((2*N))); do
    sleep 0.5
    echo -n "."
done
# stop ffmpeg on client
echo -e "\nStopping client recording on $client...\nThe video recording is being saved on $client"
sudo docker exec clab-igp-$client bash -c "pkill -f ffmpeg"

# download recording of selected client
ID=$(sudo docker ps -a | grep "clab-igp-$client" | awk '{print $1}')
sudo docker cp $ID:output_$server-$client.mp4 output_$server-$client.mp4 2> /dev/null
SUCCESS=$(ls | grep "output_$server-$client.mp4")
if [[ $SUCCESS == "output_$server-$client.mp4" ]]; then
    echo -e "The video stream was successfully saved locally !\nPlease save the video to your physical computer using sftp or VSCode Remote-SSH in order to watch it"
else
    echo -e "Error : Nothing was streamed"
fi

exit 0
