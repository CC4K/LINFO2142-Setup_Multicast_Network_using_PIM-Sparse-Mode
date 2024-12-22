#!/bin/bash

sudo clab destroy

[[ "$(command -v docker)" ]] || { echo "docker is not installed" 1>&2 ; exit 1; }
[[ "$(command -v clab)" ]] || { echo "clab is not installed" 1>&2 ; exit 1; }

sudo docker build -t host:latest -f startup_files/host.dockerfile .
sudo docker build -t router:latest -f startup_files/router.dockerfile .

sudo clab deploy

# activate firewalls
echo "Please wait for firewall to deploy"
sudo ./startup_files/execute_nftables.sh

exit 0
