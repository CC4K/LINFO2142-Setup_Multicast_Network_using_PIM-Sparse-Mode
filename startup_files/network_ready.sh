#!/bin/bash

echo "please wait a minute for the routers to find the Rendez-vous Point"
N=15
while [[ $N -gt "0" ]]; do
    res=$(./network_check.sh | grep "not")
    if echo "$res" | grep -q "not"; then
        sleep 4
        echo "."
        ((N--))
    else
        echo "✅ the network is ready !"
        exit 0
    fi
done
exit 1
