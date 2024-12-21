#!/bin/bash

echo "please wait a moment for the routers to find the Rendezvous Point"
N=20
while [[ "$N" -gt "0" ]]; do
    res=$(./network_check.sh | grep "not")
    if echo "$res" | grep -q "not"; then
        sleep 4
        echo "."
        ((N--))
        if [[ "$N" -eq "3" ]]; then
            echo "nearly done"
        fi
    else
        echo "✅ the network is ready !"
        exit 0
    fi
done
exit 1
