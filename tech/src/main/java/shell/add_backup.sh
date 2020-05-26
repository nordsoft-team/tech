#!/bin/bash
pwd
echo "disk list:"
ls "/Volumes"
read -p "Please select the main disk:" disk
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done


echo "user list:"
ls "/Volumes/$disk/Users"
read -p "Please select your user:" user
while [ ! -d "/Volumes/$disk/Users/$user" ];do read -p "error, please input again:" user; done


echo "disk list:"
ls "/Volumes"
read -p "Please select the usb disk:" usb
while [ ! -d "/Volumes/$usb" ];do read -p "error, please input again:" usb; done


echo "disk info usb:"
df -h "/Volumes/$usb"

read -p "if continue(yes/no):" yesno
while ! `echo "$yesno" | grep -qi "yes"` && ! `echo "$yesno" | grep -qi "no"`;do read -p "if continue(yes/no):" yesno; done
if `echo "$yesno" | grep -qi "no"`; then exit; fi

mkdir -p "/Volumes/$usb/QuickBackup"

echo "copying Desktop..."
cp -R "/Volumes/$disk/Users/$user/Desktop" "/Volumes/$usb/QuickBackup"

echo "done"
history -c