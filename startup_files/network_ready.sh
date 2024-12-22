#!/bin/bash

echo "Please wait a moment for the routers to decide who is BSR and RP"

N=20
while [[ "$N" -gt "0" ]]; do
    # run network_check.sh and count the number of BSRs and RPs
    output=$(./network_check.sh)
    bsr_count=$(echo "$output" | grep -c "()" )
    rp_count=$(echo "$output" | grep -c "<>" )
    # check if there is exactly one BSR and one RP
    if [[ $bsr_count -eq 1 && $rp_count -eq 1 ]]; then
        echo "✅ The network is ready !"
        exit 0
    else
        sleep 5
        echo "."
        ((N--))
        if [[ "$N" -eq "3" ]]; then
            echo "Nearly done"
        fi
    fi
done

exit 1
