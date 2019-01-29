#!/bin/bash

listOfServers="68.183.121.220
142.93.205.66
104.248.53.76
104.248.127.129"







for server in $listOfServers
do
  ssh -o StrictHostKeyChecking=no root@$server 'bash -s' < .prepare.sh
#  ssh -o StrictHostKeyChecking=no root@$server 'ifconfig'
done
