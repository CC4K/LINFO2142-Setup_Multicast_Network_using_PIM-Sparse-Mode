#!/bin/bash

array=`sudo docker ps -a | grep "clab-igp-" | awk '{print $NF}' | awk -F'-' '{print $3}'`
for router in ${array[@]}; do
    if [[ $router == r* ]]; then
        RPaddress=$(sudo docker exec clab-igp-$router vtysh -c "show ipv6 pim rp-info" | grep "fc00:2142::" | awk '{print $1}')
        RPnumber="${RPaddress##*:}"
        res2=$(sudo docker exec clab-igp-$router vtysh -c "show ipv6 pim bsr" | grep "BSR_ELECTED")
        if echo "$res2" | grep -q "BSR_ELECTED"; then
            echo "() $router is BSR"
        elif echo "$router" | grep -q "r$RPnumber"; then
            echo "<> $router is RP"
        elif echo "$RPaddress" | grep -q "$RPnumber"; then
            echo "✅ $router found that the RP is r$RPnumber"
        else
            echo "❌ $router is not the BSR nor found the RP"
        fi
    fi
done

exit 0
