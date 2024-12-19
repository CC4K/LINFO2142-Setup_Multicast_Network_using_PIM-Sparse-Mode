#!/bin/bash

sudo clab destroy

[[ "$(command -v docker)" ]] || { echo "docker is not installed" 1>&2 ; exit 1; }
[[ "$(command -v clab)" ]] || { echo "clab is not installed" 1>&2 ; exit 1; }

sudo docker build -t host:latest -f startup_files/host.dockerfile .
sudo docker build -t router:latest -f startup_files/router.dockerfile .

sudo clab deploy


## sender: iperf -c ff08:2142::56 --ipv6_domain -u -T 32 -t 0 -i 1
##   recv: iperf -s --ipv6_domain -u -B [ff08:2142::56] -i 1
