#!/bin/bash

echo -e "List of scripts available in this project :"
echo -e "> ./help.sh:\n\tShows the currently shown list of scripts available in the project"
echo -e "> ./run.sh:\n\tStarts/restarts the containerlab, waits then notifies the user when the routers are ready to send multicast packets"
echo -e "> ./stream_and_record.sh:\n\tStreams a video from a server to a client and records it on the client.\n\tThe resulting video is then downloaded to the project root where you can watch it\n\tUsage: ./stream_and_record.sh [SERVER_NAME] [CLIENT_NAME] [DURATION (optional and > 5)]\n\tExample 1: ./stream_and_record.sh h1 h3\n\tExample 2: ./stream_and_record.sh h1 h2 42"
echo -e "> ./network_check.sh:\n\tChecks if the routers are detecting the current network Rendezvous Point"
echo -e "> ./test_RP.sh:\n\tVerifies that 'r2' successfully takes over as a backup RP if the original RP 'r5' breaks down"
echo -e "> ./open.sh:\n\tOpens any container in the network.\n\tUsage: ./open.sh [CONTAINER] [INTERFACE (optional)]\n\tExample 1: ./open.sh h1\n\tExample 2: ./open.sh r2 bash"

exit 0
