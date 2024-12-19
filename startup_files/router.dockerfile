FROM quay.io/frrouting/frr:10.2.0

RUN apk update && \
    apk upgrade --no-cache --available && \
    apk add --no-cache bash bind-tools busybox-extras curl \
                       iproute2 iputils mtr net-tools procps-ng \
                       openssl perl-net-telnet tcpdump tcptraceroute \
                       wget iperf iperf3 tshark smokeping tini nmap ffmpeg ffplay ufw

ENTRYPOINT [ "/sbin/tini", "--" ]
CMD [ "/usr/bin/tail", "-f" , "/dev/null" ]
