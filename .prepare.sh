apt-get update
apt-get -y install mc apt-transport-https git nload
add-apt-repository universe
cd /tmp
rm -rf /tmp/packages-microsoft-prod.deb
apt purge -y packages-microsoft-prod
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
#wget -q https://packages.microsoft.com/config/ubuntu/16.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

apt-get -y install dotnet-sdk-2.2
#apt-get -y install aspnetcore-runtime-2.1
cat <<< '
[Unit]
Description=Canary Core

[Service]
WorkingDirectory=/home/canary/app
ExecStart=/usr/bin/dotnet /home/canary/app/Worker.dll 1250
SyslogIdentifier=canary
User=canary
Restart=always
RestartSec=10
SyslogIdentifier=canarycore
KillSignal=SIGINT
Environment=ASPNETCORE_ENVIRONMENT=Production
Environment=DOTNET_PRINT_TELEMETRY_MESSAGE=false

[Install]
WantedBy=multi-user.target
' > /etc/systemd/system/canary.service

useradd canary
mkdir /home/canary/
chown -R canary:canary /home/canary/
systemctl daemon-reload
systemctl enable canary
