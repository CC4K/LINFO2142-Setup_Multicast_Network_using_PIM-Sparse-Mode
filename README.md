# Multicast using PIM-Sarse-Mode
Note : it is recommended to view this project in VsCode using Remote Explorer extension if you are connecting via SSH



## Network topology :
```
        ┌─────┐
        │ h1  │
        └──┬──┘
           |
        ┌──┴─┐   ┌────┐
   ┌────┼ r1 ┼───┤ r3 ┼─────┐
   |    └────┘   └──┬─┘     |
┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐
| r2 ┼──┤ r4 ┼───┼ r5 ┼──┤ r6 |
└──┬─┘  └────┘   └──┬─┘  └──┬─┘
┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐
| r7 ┼──┤ r8 ┼───┼ r9 ┼──┤r10 |
└──┬─┘  └────┘   └────┘  └──┬─┘
   |                        |
┌──┴──┐                  ┌──┴──┐
│ h2  │                  │ h3  │
└─────┘                  └─────┘
```



## Testing unicast connections with `ping` and `traceroute` :
### From h1, h2, h3 :
---------------------
`ping fc00:2142::X`

`ping fc00:2142:1::1`

`ping fc00:2142:7::1`

`ping fc00:2142:a::1`

### From r1, r2, r3, r4...
--------------------------
`ping fc00:2142::X`

`ping fc00:2142:1::2`

`ping fc00:2142:7::2`

`ping fc00:2142:a::2`

## Testing multicast traffic by sending a video stream from the server h1 and recording it on a client h2 or h3 using `ffmpeg`
### Launch stream on server h1
`ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188`
### Connect to stream on client and record it
`ffmpeg -i udp://@[ff0a::1]:1234 -aspect 1280:672 -c copy output.mp4`
### Connect to stream on client and watch it (no screen though...)
`ffplay -i udp://[ff0a::1]:1234 -vf scale=1280x672`



## Step by step tutorial to launch a stream on the server h1, record it on client h2 and play it on your computer (open multiple terminals)
1. Connect to server h1 in a terminal :

`sudo docker exec -it clab-igp-h1 bash`

2. Connect to client h2 in another terminal :

`sudo docker exec -it clab-igp-h2 bash`

3. Subscribe the client to the stream and save the stream to mp4 :

`ffmpeg -i udp://@[ff0a::1]:1234 -c copy output.mp4`

4. Launch the stream on server h1 :

`ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188`

5. After ~50 seconds you can cut the subscribtion and the stream using `Ctrl+C`

6. Copy the mp4 from client h2 back to the VM / project root

`sudo docker cp a26f88586f31:output.mp4 output.mp4`

                ^           ^
                |           |
                <container_id> (`docker ps -a` to get id of all containers)
7. If you are using Remote Explorer in VsCode you can simply download the `output.mp4` video file to your computer to read it

8. Open `output.mp4` with your video player (you might need to install MMPEG-2 codec)

9. Enjoy the video !



## Debug cmds :
`show isis neighbor`

`show isis database`

`show isis route`

`ip a`

`show ipv6 mroute` (shows multicast route => to use only when a client has already joined the stream)

`show ipv6 multicast` (shows how many packets were send and recieved through the network)

`show ipv6 pim rp-info` (check who's considered the rp by a router)

`show ipv6 pim bsr candidate-bsr` (checks it the current candidate is the bsr, the one who distribute the information about the rendez-vous points)

`ip -6 route`



## What we did for now to secure our network :
Our hosts can't be candidate bsr and can't receive candidate bsr advertisement from routers
## What we want to do further but didn't have time to do it properly :
To avoid having a malicious host/router, we will limit the authorized incoming hosts/routers to the ones in the network by using the firewall.
