#!/bin/bash
echo "磁盘名称列表如下:"
ls "/Volumes"
read -p "请选择输入您的主磁盘名称后回车:" disk
while [ ! -d "/Volumes/$disk/Users" ]
do
    read -p "错误,请重新输入后回车:" disk
done

rm "/Volumes/$disk/var/db/.AppleSetupDone"
ls -al "/Volumes/$disk/var/db" | head -n 10

echo "已处理完毕"
echo "屏幕左上苹果标志→重启电脑→登录→建立新帐号→icloud点稍候设置跳过不登录→系统偏好→用户群组→修改原帐号为管理员"