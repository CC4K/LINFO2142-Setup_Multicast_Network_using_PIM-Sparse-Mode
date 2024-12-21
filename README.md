# Multicast using PIM-Sarse-Mode

##### Note : it is recommended to view this project in VsCode using Remote Explorer extension if you are connecting via SSH, it makes it easier to download the video output and navigate config files



## Project objectives
The objective of this project was to create a lab environment using FRRouting that supports PIM-Sparse-Mode and consisting of at least one sender/server streaming a video and several receivers/clients displaying it using ffmpeg to send a video stream via multicast and allowing multiple devices to access the same content without overloading the network.

We also had to choose a central location for the network Rendezvous Point (RP) and deploy security measures to avoid Rogue Servers and RP to attack the network/disrupt it.



## Network topology
<img src="network_topology.png" alt="Multicast network topology" width="1000"/>

<!-- 
Schematic of the network if you are reading this in a terminal :
> r5 is RP
> r2 is backup RP
> h1 is server
> h2 & h3 are clients
> h4 is Rogue server
```
                          ┌─────┐
                          │ h1  │ => fc00:2142:1::
                          └──┬──┘
                             |
                          ┌──┴─┐   ┌────┐
                     ┌────┼ r1 ┼───┤ r3 ┼─────┐
                     |    └────┘   └──┬─┘     |
                  ┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐    ┌─────┐
                  |<r2>┼──┤ r4 ┼───┼<r5>┼──┤ r6 ┼────┤(h4) │ => fc00:2142:6::
                  └──┬─┘  └────┘   └──┬─┘  └──┬─┘    └─────┘
                  ┌──┴─┐  ┌────┐   ┌──┴─┐  ┌──┴─┐
                  | r7 ┼──┤ r8 ┼───┼ r9 ┼──┤r10 |
                  └──┬─┘  └────┘   └──┬─┘  └────┘
                     |                |
                  ┌──┴──┐          ┌──┴──┐
 fc00:2142:7:: => │ h2  │          │ h3  │ => fc00:2142:9::
                  └─────┘          └─────┘
```
-->



## Rendezvous Point (RP) location choice
We decided the Rendezvous Point should be at the crossroad of as many routers as possible for maximum efficiency in redistributing the multicast packets between the server and the clients and in the case of our current network we found 'r5' to be perfect for this role.

Additionally we added r2 as a backup RP should r5 fail unexpectedly.

### Testing the backup Rendezvous Point
Run the script `./test_RP.sh` to verify that 'r2' does indeed take over 'r5' RP duties in case of failure. In this test scenario we manually break 'r5' by shutting it down and checking which router is detected as RP by every router in the network.



## Security against Rogue RP
Our hosts can't be candidate bsr and can't receive candidate bsr advertisement from routers

// TODO:



## Security agains Rogue sources
We limited the authorized incoming hosts to the ones already registered in the network (h1) // TODO: +++

// TODO: nft firewall

### Testing the protection against Rogue sources
// TODO: try to send stream from h4 to a client => shouldn't work



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



## Manual debugging commands for unicast and multicast and nft tables
You can access any container using `./open.sh [CONTAINER] [COMMAND PROCESSOR (optional)]` (for more details use `./help.sh`).
Note : to see multicast events on routers you need to first stream a video first !

### Testing unicast connections with `ping` or `traceroute`
From any host/router towards any router X :
```
ping fc00:2142::X
```
From any host/router towards h1 :
```
ping fc00:2142:1::
```
From any host/router towards h2 :
```
ping fc00:2142:7::
```
From any host/router towards h3 :
```
ping fc00:2142:9::
```
From any host/router towards h4 :
```
ping fc00:2142:6::
```


### Checking nft tables rules on a host
```
nft list ruleset
```
The entire list of implemented rules can also be seen in `/startup_files/nftables.sh`


### Testing multicast on a router

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

// TODO:
```
show isis neighbor
show isis database
show isis route
ip a
ip -6 route
```
