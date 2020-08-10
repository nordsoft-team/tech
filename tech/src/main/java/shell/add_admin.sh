#!/bin/bash
echo "disk list:"
ls "/Volumes"
read -p "please select the main disk:" disk
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done
cd "/Volumes/$disk"
ls -al "var/db" | head -n 10
rm "var/db/.AppleSetupDone"
ls -al "var/db" | head -n 10

#OK for Mojave
echo "Done, restart and skip the Apple ID"