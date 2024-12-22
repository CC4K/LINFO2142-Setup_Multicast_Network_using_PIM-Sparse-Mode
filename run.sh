sudo ./startup_files/run_helper.sh
#output=$(sudo docker exec clab-igp-h1 -c "ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff06::179]:50623?pkt_size=188" 2>&1)

#if echo "$output" | grep "Error submitting a packet to the muxer: Operation not permitted"; then
#    echo "error with the firewall"
#    echo "relaunch containers"
#    sudo ./startup_files/run_helper.sh
#fi
# start checking when the network is ready
sudo ./startup_files/network_ready.sh
