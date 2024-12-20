#!/bin/bash

while [[ 1 ]]; do
    res=$(bash ../network_check.sh | grep "down")
    if echo "$res" | grep -q "down"; then
        echo "wait for it"
        sleep 5
    else
        echo "the network is ready !"
        break
    fi
done
exit 0
