# Multicast using PIM-Sarse-Mode

##### Note : it is recommended to view this project in VsCode using Remote Explorer extension if you are connecting via SSH, it makes it easier to download the video output and navigate configuration files

## Project objectives
The objective of this project was to create a lab environment using FRRouting that supports PIM-Sparse-Mode and consisting of at least one sender/server streaming a video and several receivers/clients displaying it using ffmpeg to send a video stream via multicast and allowing multiple devices to access the same content without overloading the network.

Considering there is no screen on the end clients to watch the stream we record the stream and save a part of it on the client and download it to our own real computer to watch it.


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
                           ┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐    ┌─────┐
                           |<r2>┼──┤ r4 ┼───┼<r5>┼──┤ r6 ┼────┤ h4  │ => fc00:2142:6::
                           └──┬─┘  └────┘   └──┬─┘  └──┬─┘    └─────┘
                           ┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐
                           | r7 ┼──┤ r8 ┼───┼ r9 ┼──┤r10 |
                           └──┬─┘  └────┘   └──┬─┘  └────┘
                              |                |
                           ┌──┴──┐          ┌──┴──┐
         fc00:2142:7::  => │ h2  │          │ h3  │ => fc00:2142:9::
                           └─────┘          └─────┘
```
## Rendezvous Point (RP) location choice
We decided the Rendezvous Point should be at the crossroad of as many routers as possible for maximum efficiency in redistributing the multicast packets between servers and clients and in the case of our current network r5 is perfect in this role.

We also added r2 as a backup RP should r5 fail unexpectedly.

## Security against Rogue sources and RP
Our hosts can't be candidate bsr and can't receive candidate bsr advertisement from routers

// TODO:

## What we want to do further but didn't have time to do it properly
To avoid having a malicious host/router, we will limit the authorized incoming hosts/routers to the ones in the network by using the firewall.

// TODO:


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


## Launch a stream on the server h1, record it on client h2 and play it on your physical computer
### 1. Run the automated script for streaming and recording :
```
sudo ./stream_and_record.sh
```
This will start a stream on the server, subscribe the h2 client to it, record a ~20 seconds video of the stream and save it to the project root.

// TODO: wait time

### 2. Download the video output from this folder to your physical computer :
&rarr; Using VSCode Remote-SSH : right-click the video file and save it
&rarr; Using sftp (saves the file in your user folder) :
```
sftp vm
sftp> get setup_multicast_using_PIM-SM/output.mp4
```

### 3. Open `output.mp4` with your favorite video player (you might need to install MMPEG-2 codec to read it)

### 4. Enjoy the video !



## Debug commands for multicast and others
##### Note : a video needs to be streamed and a client subscribed to the video stream for multicast packets to move around and be visible
// TODO: commands for starting stream

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
