#!/bin/bash

# usage :
# ./stream_and_record.sh <server> <client> <duration(optional)>
# example usage :
# ./stream_and_record.sh h1 h2 10


# check if exactly two arguments are provided
if [[ $# -lt 2 ]]; then
    echo "error: exactly two arguments are required"
    exit 1
fi
# check if the first argument is a server (h1 or h4)
if [[ "$1" != "h1" && "$1" != "h4" ]]; then
    echo "error: $1 is not a server"
    exit 1
fi
server="$1"
# check if the second argument is a client (h2 or h3)
if [[ "$2" != "h2" && "$2" != "h3" ]]; then
    echo "error: $2 is not a client"
    exit 1
fi
client="$2"
if [[ $# -eq 3 ]]; then
    # Check if the third argument is a number > 5
    if ! [[ "$3" =~ ^[0-9]+$ ]] || [[ "$3" -le 5 ]]; then
        echo "error: third argument must be > 5"
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
echo -e "starting stream..."
sudo docker exec -d clab-igp-$server bash -c "ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff06::179]:50623?pkt_size=188"
echo -e "stream started !\n"
# subscribe to stream and record on client
echo -e "subscribing to stream..."
sudo docker exec -d clab-igp-$client bash -c "ffmpeg -i udp://@[ff06::179]:50623 -c copy output_$server-$client.mp4"
echo -e "watching stream !"
# watching stream for N seconds
for i in $(seq 1 $((2*N))); do
    sleep 0.5
    echo -n "."
done

# stop ffmpeg on client
echo -e "\nstopping client recording..."
sudo docker exec clab-igp-$client bash -c "pkill -f ffmpeg"
# stop ffmpeg on server
echo -e "stopping server stream...\n"
sudo docker exec clab-igp-$server bash -c "pkill -f ffmpeg"

# download recordings of all selected clients
ID=$(sudo docker ps -a | grep "clab-igp-$client" | awk '{print $1}')
sudo docker cp $ID:output_$server-$client.mp4 output_$server-$client.mp4 2> /dev/null
SUCCESS=$(ls | grep "output_$server-$client.mp4")
if [[ $SUCCESS == "output_$server-$client.mp4" ]]; then
    echo -e "video stream was successfully saved locally !\nplease save the video to your physical computer using sftp or VSCode Remote-SSH in order to watch it"
else
    echo -e "error : nothing was streamed"
fi
exit 0
