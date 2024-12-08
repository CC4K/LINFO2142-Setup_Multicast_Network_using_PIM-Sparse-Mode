
```
                       ┌─────┐         
                       │  h2 │         
                       └──┬──┘         
               ┌────┐  ┌──┴─┐          
            ┌──┼ S2 ┼──┤ S3 ┼──┐       
            │  └────┘  └──┬─┘  │       
┌──────┐ ┌──┼─┐           │  ┌─┼──┐
│  h1  ├─┼ S1 │  ┌────────┘  │ S6 │
└──────┘ └──┬─┘  │           └─┬──┘
            │  ┌─┼──┐  ┌────┐  │       
            └──┼ S4 ├──┼ S5 ┼──┘       
               └────┘  └──┬─┘          
                       ┌──┴──┐         
                       │ h3  │         
                       └─────┘         
```
Pings :
-------
==h1,2,3==
ping fc00:2142::X
ping fc00:2142:1::1
ping fc00:2142:3::1
ping fc00:2142:5::1
==s1,2,3,4,5,6==
ping fc00:2142::X
ping fc00:2142:1::2
ping fc00:2142:3::2
ping fc00:2142:5::2

Stream cmds :
-------------
// Server
// stream
ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188
// send video (doesn't work...)
ffmpeg -re -i input.mp4 -f mpegts udp://[ff0a::1]:1234

// Client
// save (works)
ffmpeg -i udp://@[ff0a::1]:1234 -aspect 1280:672 -c copy output.mp4
// stream (no screen though...)
ffplay -i udp://[ff0a::1]:1234 -vf scale=1280x672

Debug cmds :
------------
show isis neighbor
show isis database
show isis route
ip a
(traceroute6 fc00:2142::3) => pas installé, équivalent ??
show ipv6 mroute

Stream, save and read, tutorial :
---------------------------------
Server / h1 :
sudo docker exec -it clab-igp-h1 bash

Client / h2 :
sudo docker exec -it clab-igp-h2 bash
ffmpeg -i udp://@[ff0a::1]:1234 -c copy output.mp4

Server / h1 :
ffmpeg -re -stream_loop -1 -i input.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188

On VM :
sudo docker cp f4cf3d2f01c9:output.mp4 output.mp4
              <container_id>
On PC :
Download and play !
