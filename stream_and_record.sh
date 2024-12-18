#!/bin/bash

# delete preexisting video files on h2
docker exec clab-igp-h2 bash -c "rm *.mp4" 2> /dev/null

# launch stream on server h1
echo -e "starting stream..."
docker exec -d clab-igp-h1 bash -c "ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188"
echo -e "stream started !\n"

# subscribe to stream and record on h2
echo -e "subscribing to stream..."
docker exec -d clab-igp-h2 bash -c "ffmpeg -i udp://@[ff0a::1]:1234 -c copy output.mp4"
echo -e "watching stream !"

# watching stream for N seconds
N=42
for i in $(seq 1 $((2*N))); do
    sleep 0.5
    echo -n "."
done

# stop ffmpeg on client h2
echo -e "\nstopping client recording..."
docker exec clab-igp-h2 bash -c "pkill -f ffmpeg"

# stop ffmpeg on server h1
echo -e "stopping server stream...\n"
docker exec clab-igp-h1 bash -c "pkill -f ffmpeg"

# download recordings of all selected clients
IDh2=$(docker ps -a | grep "clab-igp-h2" | awk '{print $1}')
docker cp $IDh2:output.mp4 output.mp4 > /dev/null
echo -e "video stream was successfully saved locally !\nplease save the video to your physical computer using sftp or VSCode Remote-SSH in order to watch it"

# notes :
# ça marche pr h2 :D
# mtnt faire la même chose pr recevoir une autre vidéo sur h3 ça serait nickel ! (ajouter un autre serveur du coup ?)
