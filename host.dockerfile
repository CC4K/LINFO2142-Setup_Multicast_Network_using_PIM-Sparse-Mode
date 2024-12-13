FROM alpine:3.20

RUN apk update && \
    apk upgrade --no-cache --available && \
    apk add --no-cache bash bind-tools busybox-extras curl \
                       iproute2 iputils mtr net-tools procps-ng \
                       openssl perl-net-telnet tcpdump tcptraceroute \
                       wget iperf iperf3 tshark smokeping tini nmap ffmpeg ffplay ufw

copy input.mp4 input.mp4

ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/usr/bin/tail", "-f" , "/dev/null" ]
