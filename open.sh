#!/bin/bash

if [[ $1 == r* ]]; then
    N=${1:1}
    CONTAINER="clab-igp-$1"
    docker exec -it "$CONTAINER" vtysh 2> /dev/null
elif [[ $1 == h* ]]; then
    N=${1:1}
    CONTAINER="clab-igp-$1"
    docker exec -it "$CONTAINER" bash 2> /dev/null
fi
