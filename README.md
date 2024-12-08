
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
Pings :
-------
==h1,2,3==
ping fc00:2142::X
ping fc00:2142:1::1
ping fc00:2142:8::1
ping fc00:2142:11::1
==s1,2,3,4,5...==
ping fc00:2142::X
ping fc00:2142:1::2
ping fc00:2142:8::2
ping fc00:2142:11::2

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
show ipv6 mroute
show ipv6 multicast
show ipv6 pim rp-info
ip -6 route


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
sudo docker cp 3b5512dd9253:output.mp4 output.mp4
              <container_id>
On PC :
Download and play !
