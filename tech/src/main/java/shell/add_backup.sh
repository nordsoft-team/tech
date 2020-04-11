#!/bin/bash
pwd
echo "disk list:"
ls "/Volumes"
read -p "please select the main disk:" disk
while [ ! -d "/Volumes/$disk/Users" ];do read -p "error, please input again:" disk; done

echo "disk list:"
ls "/Volumes"
read -p "please select the usb disk:" usb
while [ ! -d "/Volumes/$usb" ];do read -p "error, please input again:" usb; done

echo "user list:"
ls "/Volumes/$disk/Users"
read -p "please select your user:" user
while [ ! -d "/Volumes/$disk/Users/$user" ];do read -p "error, please input again:" user; done


mkdir -p "/Volumes/$usb/QuickBackup"

echo "copying Desktop..."
cp -R "/Volumes/$disk/Users/$user/Desktop" "/Volumes/$usb/QuickBackup"

echo "copying Downloads..."
cp -R "/Volumes/$disk/Users/$user/Downloads" "/Volumes/$usb/QuickBackup"

echo "copying Downloads..."
cp -R "/Volumes/$disk/Users/$user/Documents" "/Volumes/$usb/QuickBackup"

echo "copying ..."
cp -R "/Volumes/$disk/Users/$user/Pictures" "/Volumes/$usb/QuickBackup"

echo "done"