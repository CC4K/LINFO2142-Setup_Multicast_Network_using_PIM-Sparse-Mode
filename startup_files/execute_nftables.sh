#!/bin/bash

docker exec clab-igp-h1 bash -c "./etc/nftables.sh"
docker exec clab-igp-h2 bash -c "./etc/nftables.sh"
docker exec clab-igp-h3 bash -c "./etc/nftables.sh"
docker exec clab-igp-h4 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r1 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r2 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r3 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r4 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r5 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r6 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r7 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r8 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r9 bash -c "./etc/nftables.sh"
#docker exec -d clab-igp-r10 bash -c "./etc/nftables.sh"
exit 0
