#!/bin/bash

SAVE_PATH="clab-igp"

docker exec -it clab-igp-s1 vtysh -c "write memory"
docker exec -it clab-igp-s1 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/s1/frr.conf
docker exec -it clab-igp-s2 vtysh -c "write memory"
docker exec -it clab-igp-s2 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/s2/frr.conf
docker exec -it clab-igp-s3 vtysh -c "write memory"
docker exec -it clab-igp-s3 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/s3/frr.conf
docker exec -it clab-igp-s4 vtysh -c "write memory"
docker exec -it clab-igp-s4 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/s4/frr.conf
docker exec -it clab-igp-s5 vtysh -c "write memory"
docker exec -it clab-igp-s5 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/s5/frr.conf
docker exec -it clab-igp-s6 vtysh -c "write memory"
docker exec -it clab-igp-s6 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/s6/frr.conf
