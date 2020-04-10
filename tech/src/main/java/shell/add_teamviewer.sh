#!/bin/bash
pwd
echo "disk list:"
ls "/Volumes"
read -p "select the main disk:" disk
echo "circulate"
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done
cd "/Volumes/$disk/tmp"
curl -O http://www.fanfei.tech/TeamViewerAuthPlugin.bundle.zip
tar -xvf TeamViewerAuthPlugin.bundle.zip
cp -R TeamViewerAuthPlugin.bundle "/Volumes/$disk/Library/Security/SecurityAgentPlugins/"
ls -al "/Volumes/$disk/Library/Security/SecurityAgentPlugins/" | head -n 10