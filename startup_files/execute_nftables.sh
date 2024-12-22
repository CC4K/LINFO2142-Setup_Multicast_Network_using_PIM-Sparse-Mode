#!/bin/bash

# start the firewall on the hosts
docker exec clab-igp-h1 bash -c "./etc/nftables.sh"
docker exec clab-igp-h2 bash -c "./etc/nftables.sh"
docker exec clab-igp-h3 bash -c "./etc/nftables.sh"
docker exec clab-igp-h4 bash -c "./etc/nftables.sh"

exit 0
