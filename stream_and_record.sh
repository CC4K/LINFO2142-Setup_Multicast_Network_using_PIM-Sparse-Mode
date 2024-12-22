#!/bin/bash

# check if exactly two arguments are provided
if [[ $# -lt 2 ]]; then
    echo "Error: At least two arguments are required"
    echo -e "> ./stream_and_record.sh:\n\tStreams a video from a server to a client and records it on the client.\n\tThe resulting video is then downloaded to the project root where you can watch it\n\tUsage: ./stream_and_record.sh [SERVER_NAME] [CLIENT_NAME] [DURATION (optional and > 5)]\n\tExample 1: ./stream_and_record.sh h1 h3\n\tExample 2: ./stream_and_record.sh h1 h2 42"
    exit 1
fi
# check if the first argument is a server (h1 or h4)
if [[ "$1" != "h1" && "$1" != "h4" ]]; then
    echo "Error: $1 is not a server"
    echo -e "> ./stream_and_record.sh:\n\tStreams a video from a server to a client and records it on the client.\n\tThe resulting video is then downloaded to the project root where you can watch it\n\tUsage: ./stream_and_record.sh [SERVER_NAME] [CLIENT_NAME] [DURATION (optional and > 5)]\n\tExample 1: ./stream_and_record.sh h1 h3\n\tExample 2: ./stream_and_record.sh h1 h2 42"
    exit 1
fi
server="$1"
# check if the second argument is a client (h2 or h3)
if [[ "$2" != "h2" && "$2" != "h3" ]]; then
    echo "Error: $2 is not a client"
    echo -e "> ./stream_and_record.sh:\n\tStreams a video from a server to a client and records it on the client.\n\tThe resulting video is then downloaded to the project root where you can watch it\n\tUsage: ./stream_and_record.sh [SERVER_NAME] [CLIENT_NAME] [DURATION (optional and > 5)]\n\tExample 1: ./stream_and_record.sh h1 h3\n\tExample 2: ./stream_and_record.sh h1 h2 42"
    exit 1
fi
client="$2"
if [[ $# -eq 3 ]]; then
    # Check if the third argument is a number > 5
    if ! [[ "$3" =~ ^[0-9]+$ ]] || [[ "$3" -le 5 ]]; then
        echo "Error: Third optional argument must be > 5"
        echo -e "> ./stream_and_record.sh:\n\tStreams a video from a server to a client and records it on the client.\n\tThe resulting video is then downloaded to the project root where you can watch it\n\tUsage: ./stream_and_record.sh [SERVER_NAME] [CLIENT_NAME] [DURATION (optional and > 5)]\n\tExample 1: ./stream_and_record.sh h1 h3\n\tExample 2: ./stream_and_record.sh h1 h2 42"
        exit 1
    fi
    N="$3"
else
    N=20
fi

# delete preexisting video files from client
if [[ "$client" == "h2" ]]; then
    sudo rm output_$server-h2.mp4 2> /dev/null
fi
if [[ "$client" == "h3" ]]; then
    sudo rm output_$server-h3.mp4 2> /dev/null
fi
sudo docker exec clab-igp-$client bash -c "rm *.mp4" 2> /dev/null

# launch stream on server
echo -e "Starting stream on server $server..."
sudo docker exec -d clab-igp-$server bash -c "ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff06::179]:50623?pkt_size=188"
echo -e "Server $server started streaming !\n"
# subscribe to stream and record on client
echo -e "Client $client subscribing to the stream..."
sudo docker exec -d clab-igp-$client bash -c "ffmpeg -i udp://@[ff06::179]:50623 -c copy output_$server-$client.mp4"
echo -e "Client $client is watching the stream"
# watching stream for N seconds
echo -n "Recording"
for i in $(seq 1 $((2*N))); do
    sleep 0.5
    echo -n "."
done

# stop ffmpeg on client
echo -e "\n\nStopping client recording on $client...\nThe video recording is being saved on $client"
sudo docker exec clab-igp-$client bash -c "pkill -f ffmpeg"
# stop ffmpeg on server
echo -e "Stopping server stream on $server...\n"
sudo docker exec clab-igp-$server bash -c "pkill -f ffmpeg"

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
