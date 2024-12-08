
```text
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
pings :
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


(
// stream
ffmpeg -re -stream_loop -1 -i video.mp4 -c:a aac -b:a 128k -ar 44100 -f mpegts udp://[ff0a::1]:1234?pkt_size=188
)


// server
ffmpeg -re -i video.mp4 -f mpegts udp://[ff0a::1]:1234

// client
// save
ffmpeg -i udp://@[ff0a::1]:1234 -aspect 1280:672 -c copy output.mp4
// stream
ffplay -i udp://[ff0a::1]:1234 -vf scale=1280x672


// save video
sudo docker cp ade3bf96a06a:output.mp4 output.mp4
