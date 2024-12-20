#!/bin/bash

array=`sudo docker ps -a | grep "clab-igp-" | awk '{print $NF}' | awk -F'-' '{print $3}'`

for router in ${array[@]}; do
    if [[ $router == r* ]]; then
        res=$(sudo docker exec clab-igp-$router vtysh -c "show ipv6 pim rp-info")
        if echo "$res" | grep -q "fc00:2142::"; then
            echo "$router is up"
        else
            echo "$router is down"
        fi
    fi
done
exit 0
