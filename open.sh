#!/bin/bash

# check arguments
if [ -z "$1" ]; then
    echo "error : missing argument"
    exit 1
fi
if [ -z "$2" ]; then
    console_router="vtysh"
else
    console_router="$2"
fi

# parse if router or host
N=${1:1}
container="clab-igp-$1"
if [[ $1 == r* ]]; then
    sudo docker exec -it "$container" "$console_router"
elif [[ $1 == h* ]]; then
    sudo docker exec -it "$container" bash
fi
exit 0
