#!/bin/bash

SAVE_PATH="clab-igp"

sudo docker exec -it clab-igp-r1 vtysh -c "write memory"
sudo docker exec -it clab-igp-r1 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r1/frr.conf
sudo docker exec -it clab-igp-r2 vtysh -c "write memory"
sudo docker exec -it clab-igp-r2 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r2/frr.conf
sudo docker exec -it clab-igp-r3 vtysh -c "write memory"
sudo docker exec -it clab-igp-r3 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r3/frr.conf
sudo docker exec -it clab-igp-r4 vtysh -c "write memory"
sudo docker exec -it clab-igp-r4 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r4/frr.conf
sudo docker exec -it clab-igp-r5 vtysh -c "write memory"
sudo docker exec -it clab-igp-r5 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r5/frr.conf
sudo docker exec -it clab-igp-r6 vtysh -c "write memory"
sudo docker exec -it clab-igp-r6 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r6/frr.conf
sudo docker exec -it clab-igp-r7 vtysh -c "write memory"
sudo docker exec -it clab-igp-r7 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r7/frr.conf
sudo docker exec -it clab-igp-r8 vtysh -c "write memory"
sudo docker exec -it clab-igp-r8 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r8/frr.conf
sudo docker exec -it clab-igp-r9 vtysh -c "write memory"
sudo docker exec -it clab-igp-r9 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r9/frr.conf
sudo docker exec -it clab-igp-r10 vtysh -c "write memory"
sudo docker exec -it clab-igp-r10 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r10/frr.conf
exit 0
