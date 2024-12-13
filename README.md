# Multicast using PIM-Sarse-Mode

##### Note : it is recommended to view this project in VsCode using Remote Explorer extension if you are connecting via SSH, it makes it easier to download the video output and open multiple terminals at once

## Project objectives
The objective of this project was to create a small lab environment using FRRouting that supports PIM-SM and consisting of at least one sender/server streaming a video and several receivers/clients displaying it using ffmpeg to send a video stream via multicast and allowing multiple devices to access the same content without overloading the network.

Considering there is no screen on the end clients to watch the stream we record and save a part of it on the client and download it to our own real computer to watch it.


## Network topology
![Alt text](network_topology.png "Multicast network topology")
```
                                   ┌─────┐
                                   │ h1  │ => fc00:2142:1::
                                   └──┬──┘
                                      |
                                   ┌──┴─┐   ┌────┐
                              ┌────┼ r1 ┼───┤ r3 ┼─────┐
                              |    └────┘   └──┬─┘     |
                           ┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐
                           |<r2>┼──┤ r4 ┼───┼<r5>┼──┤ r6 |
                           └──┬─┘  └────┘   └──┬─┘  └──┬─┘
                           ┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐
                           | r7 ┼──┤ r8 ┼───┼ r9 ┼──┤r10 |
                           └──┬─┘  └────┘   └────┘  └──┬─┘
                              |                        |
                           ┌──┴──┐                  ┌──┴──┐
         fc00:2142:7::  => │ h2  │                  │ h3  │ => fc00:2142:a::
                           └─────┘                  └─────┘
```
## Rendezvous Point (RP) location choice
We decided the Rendezvous Point should be at the crossroad of as many routers as possible for maximum efficiency in redistributing the multicast packets between servers and clients and in the case of out current network r5 is perfect in this role.

We also added r2 as a backup RP should r5 fail unexpectedly.

## Security against Rogue sources and RP
Our hosts can't be candidate bsr and can't receive candidate bsr advertisement from routers

## What we want to do further but didn't have time to do it properly
To avoid having a malicious host/router, we will limit the authorized incoming hosts/routers to the ones in the network by using the firewall.



----------------------------------------------------------------------------------
----------------------------------------------------------------------------------



## Testing unicast connections with `ping` or `traceroute`
### From any host/router towards any router X :
```
ping fc00:2142::X
```
### From any host/router towards h1 :
```
ping fc00:2142:1::
```
### From any host/router towards h2 :
```
ping fc00:2142:7::
```
### From any host/router towards h3 :
```
ping fc00:2142:a::
```


<!--

## Testing multicast traffic by sending a video stream from the server h1 and recording it on client h2 using `ffmpeg`
### Launch stream on server h1
```
ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188
```
### Connect to stream on client and record it
```
ffmpeg -i udp://@[ff0a::1]:1234 -aspect 1280:672 -c copy output.mp4
```
### Connect to stream on client and watch it (no screen though...)
```
ffplay -i udp://[ff0a::1]:1234 -vf scale=1280x672
```

-->



## Step by step tutorial to launch a stream on the server h1, record it on client h2 and play it on your computer (open multiple terminals)
### 1. Connect to server h1 in a terminal :
```
sudo docker exec -it clab-igp-h1 bash
```

### 2. Connect to client h2 in another terminal :
```
sudo docker exec -it clab-igp-h2 bash
```

### 3. Subscribe the client h2 to the stream and save the stream to mp4 :
```
ffmpeg -i udp://@[ff0a::1]:1234 -c copy output.mp4
```

### 4. Launch the stream on server h1 :
```
ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188
```

### 5. After ~50 seconds you can cut the subscription and the stream using `Ctrl+C`

### 6. Copy the .mp4 from client h2 back to the VM / project root
```
sudo docker cp a26f88586f31:output.mp4 output.mp4
               ^           ^
               |           |
           <client_container_id> (`docker ps -a` to get id of all containers)
```
### 7. If you are using Remote Explorer in VsCode you can simply download the `output.mp4` video file to your computer to read it

### 8. Open `output.mp4` with your video player (you might need to install MMPEG-2 codec)

### 9. Enjoy the video !



## Debug commands for multicast and others
##### Note : a video needs to be streamed and a client subscribed to the video stream for multicast packets to move around and be visible

#### Show multicast route => to use only when a client has already joined the stream :
```
show ipv6 mroute
```
#### Show how many packets were send and received through the network :
```
show ipv6 multicast
```
#### Check who is considered the RP by a router :
```
show ipv6 pim rp-info
```
#### Check if the current candidate is the bsr (the one who distribute the information about the RP's)
```
show ipv6 pim bsr candidate-bsr
```
```
show isis neighbor
show isis database
show isis route
ip a
ip -6 route
```
