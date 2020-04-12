#!/bin/bash
pwd
echo "disk list:"
ls "/Volumes"
read -p "please select the main disk:" disk
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done
cd "/Volumes/$disk"
ls -al "var/db" | head -n 10
rm "var/db/.AppleSetupDone"
ls -al "var/db" | head -n 10

echo "done, restart and don't use icloud"