#!/bin/bash

echo -e "List of scripts available in this project :"

echo -e "> ./help.sh\n\tShows the currently shown list of scripts available in the project"
echo -e "> ./permissions.sh\n\tGives execute permissions to all other bash scripts in the project\n\tDon't forget to first give permissions to this script with 'sudo chmod 777' before trying to run it"
echo -e "> ./run.sh\n\tStarts/restarts the containerlab then notifies the user when the firewall is deployed and the routers are ready to send multicast packets"

echo -e "> ./open.sh\n\tOpens any container in the network\n\tUsage: ./open.sh [CONTAINER] [INTERFACE (optional)]\n\tExample 1: ./open.sh h1\n\tExample 2: ./open.sh r2 bash"

echo -e "> ./stream.sh\n\tStarts a stream on the specified server\n\tIf the server trying to start a stream is considered external to the network it will be stopped by the firewall and an error will be thrown\n\tUsage: ./stream.sh [SERVER_NAME]\n\tExample: ./stream.sh h1"
echo -e "> ./watch_and_record.sh\n\tWatches and records the video stream coming from the server onto the specified client\n\tThe resulting video recording is then downloaded to the project root where you can watch it\n\tUsage: ./watch_and_record.sh [CLIENT_NAME] [DURATION (optional and > 5 seconds)]\n\tExample 1: ./watch_and_record.sh h3\n\tExample 2: ./watch_and_record.sh h2 42"
echo -e "> ./network_check.sh\n\tChecks if the routers are detecting the current network Rendezvous Point and shows who the BSR and RP are"
echo -e "> ./test_RP.sh\n\tVerifies that 'r2' successfully takes over as a backup RP if the original RP 'r5' breaks down"

exit 0
