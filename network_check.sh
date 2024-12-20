#!/bin/bash

array=`sudo docker ps -a | grep "clab-igp-" | awk '{print $NF}' | awk -F'-' '{print $3}'`

for router in ${array[@]}; do
    if [[ $router == r* ]]; then
        res=$(sudo docker exec clab-igp-$router vtysh -c "show ipv6 pim rp-info" | grep "fc00:2142::" | awk '{print $1}')
        parsed="${res##*:}"
        if echo -s "$res" | grep -q "fc00:2142::"; then
            echo "✅ $router found that the RP is r$parsed"
        else
            echo "❌ $router did not find the RP"
        fi
    fi
done
exit 0
