#!/bin/bash

# verifiy that r5 indeed RP
echo "currently detected Rendez-vous Point should be r5 :"
./network_check.sh

# shutdown r5
sudo docker exec clab-igp-r5 bash -c "sed -i '/^interface lo/a \ shutdown' /etc/frr/frr.conf" # add shutdown
sudo docker exec clab-igp-r5 bash -c "/etc/init.d/frr reload" > /dev/null 2>&1 # reload frr
echo -e "\nr5 is now down and no longer Rendez-vous Point !\n"
sleep 7

# verifiy that r2 is new RP
echo "currently detected Rendez-vous Point should now be r2 :"
./network_check.sh

# repair r5 in a few seconds like a boss
sudo docker exec clab-igp-r5 bash -c "sed -i '/^ shutdown/d' /etc/frr/frr.conf" # remove shutdown
sudo docker exec clab-igp-r5 bash -c "/etc/init.d/frr reload" > /dev/null 2>&1 # reload frr
sleep 6
echo -e "."
sleep 6
echo -e "please wait..."
sleep 6
echo -e "."
sleep 6

# verifiy that r5 is back to being RP
echo "currently detected Rendez-vous Point should be r5 again :"
./network_check.sh

exit 0
