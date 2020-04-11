#!/bin/bash
pwd
echo "disk list:"
ls "/Volumes"
read -p "select the main disk:" disk
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done
cd "/Volumes/$disk"
rm "var/db/.AppleSetupDone"
ls -al "var/db" | head -n 10

echo "over, please don't use icloud"