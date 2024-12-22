#!/bin/bash

# destroy preexisting containers
sudo clab destroy

# check if docker and containerlab are installed
[[ "$(command -v docker)" ]] || { echo "docker is not installed" 1>&2 ; exit 1; }
[[ "$(command -v clab)" ]] || { echo "clab is not installed" 1>&2 ; exit 1; }

# build images
sudo docker build -t host:latest -f startup_files/host.dockerfile .
sudo docker build -t router:latest -f startup_files/router.dockerfile .

# launch containers
sudo clab deploy

# activate firewalls
echo "Please wait for firewall to deploy"
sudo ./startup_files/execute_nftables.sh
echo "Firewall deployed !"

# start checking when the routers have settled
sudo ./startup_files/network_ready.sh

exit 0
