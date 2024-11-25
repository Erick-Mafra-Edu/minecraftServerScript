#!/bin/bash
echo "defina o nome do servidor | define name of server"
read serverName
echo "$serverName"
mkdir "/var/$serverName/"
groupadd -r $serverName
useradd -r -g "$serverName" -d "/var/$serverName" -s "/bin/bash" "$serverName"
chown $serverName:$serverName -R "/var/$serverName/"
touch "/etc/systemd/system/$serverName.service"
echo "select 
1) for minecraft Vanilla
2) for minecraft Fabric"
read mineType
case $mineType in 
1) echo "escreva a versão vanilla"
read mineVersion 
curl "https://serverjar.org/download/spigot/$mineVersion" -o "/var/$serverName/server.jar";;
2) echo "escreva a versão do Minecraft Fabric"
read mineVersion
echo "escreva a versão do Fabric"
read fabricVersion
curl "https://meta.fabricmc.net/v2/versions/loader/$mineVersion/$fabricVersion/1.0.1/server/jar" -o "/var/$serverName/server.jar" ;;
*) echo "Wtf";;
esac


##echo "escreva a versão do Minecraft Fabric"
##read mineVersion
##echo "escreva a versão do Fabric"
##read fabricVersion
##curl -OJ "https://meta.fabricmc.net/v2/versions/loader/$mineVersion/$fabricVersion/1.0.1/server/jar"
echo "
[Unit]
Description=$serverName Server

Wants=network.target
After=network.target

[Service]
User=$serverName
Group=$serverName
Nice=5
KillMode=control-group
SuccessExitStatus=0 1

ProtectHome=true
ProtectSystem=full
PrivateDevices=true
NoNewPrivileges=true
PrivateTmp=true
InaccessibleDirectories=/root /sys /srv -/opt /media -/lost+found
ReadWriteDirectories=/var/$serverName/
WorkingDirectory=/var/$serverName/
ExecStart=/usr/bin/java -Xmx2G -jar server.jar nogui

[Install]
WantedBy=multi-user.target
" > "/etc/systemd/system/$serverName.service"