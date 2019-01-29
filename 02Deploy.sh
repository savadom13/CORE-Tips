#!/bin/bash

listOfServers="68.183.121.220
142.93.205.66
104.248.53.76
104.248.127.129"

cd /tmp
rm -rf /tmp/Canary.Core
git clone https://4paws.visualstudio.com/Canary.Core/_git/Canary.Core
cd Canary.Core/Canary.Core/
dotnet publish -c Release -o app


for server in $listOfServers
do
    ssh -o StrictHostKeyChecking=no root@$server 'systemctl stop canary'
    ssh -o StrictHostKeyChecking=no root@$server 'rm -fr /home/canary/app_old'
    ssh -o StrictHostKeyChecking=no root@$server 'mv /home/canary/app /home/canary/app_old'
    scp -r /tmp/Canary.Core/Canary.Core/Worker/app root@$server:/home/canary
    ssh -o StrictHostKeyChecking=no root@$server 'chown -R canary:canary /home/canary/app'
    ssh -o StrictHostKeyChecking=no root@$server 'systemctl start canary'
done

