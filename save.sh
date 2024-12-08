#!/bin/bash

SAVE_PATH="clab"

docker exec -it clab-r1 vtysh -c "write memory"
docker exec -it clab-r1 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r1/frr.conf
docker exec -it clab-r2 vtysh -c "write memory"
docker exec -it clab-r2 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r2/frr.conf
docker exec -it clab-r3 vtysh -c "write memory"
docker exec -it clab-r3 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r3/frr.conf
docker exec -it clab-r4 vtysh -c "write memory"
docker exec -it clab-r4 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r4/frr.conf
docker exec -it clab-r5 vtysh -c "write memory"
docker exec -it clab-r5 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r5/frr.conf
docker exec -it clab-r7 vtysh -c "write memory"
docker exec -it clab-r7 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r7/frr.conf
docker exec -it clab-r8 vtysh -c "write memory"
docker exec -it clab-r8 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r8/frr.conf
docker exec -it clab-r9 vtysh -c "write memory"
docker exec -it clab-r9 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r9/frr.conf
docker exec -it clab-r10 vtysh -c "write memory"
docker exec -it clab-r10 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r10/frr.conf
docker exec -it clab-r11 vtysh -c "write memory"
docker exec -it clab-r11 cat "/etc/frr/frr.conf" > ${SAVE_PATH}/r11/frr.conf
