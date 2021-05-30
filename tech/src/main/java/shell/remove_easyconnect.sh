#!/bin/bash

function removeFile(){
    if `echo "$1" | grep -qi "sangfor"` || `echo "$1" | grep -qi "easyconnect"`
    then
      echo "$1"; sudo rm -rf "$1";
    fi
}

#REMOVE FILES
for file in /Applications/*; do removeFile "$file"; done;
for file in /Applications/Utilities/*; do removeFile "$file"; done;
for file in /Library/Application\ Support/*; do removeFile "$file"; done;
for file in /Library/Internet\ Plug-Ins/*; do removeFile "$file"; done;
for file in /Library/LaunchAgents/*; do removeFile "$file"; done;
for file in /Library/LaunchDaemons/*; do removeFile "$file"; done;
for file in /Library/Preferences/*; do removeFile "$file"; done;
for file in /Library/PreferencePanes/*; do removeFile "$file"; done;
for file in /Library/PrivilegedHelperTools/*; do removeFile "$file"; done;
for file in ~/Library/Application\ Support/*; do removeFile "$file"; done;
for file in ~/Library/Containers/*; do removeFile "$file"; done;
for file in ~/Library/Group\ Containers/*; do removeFile "$file"; done;
for file in ~/Library/LaunchAgents/*; do removeFile "$file"; done;
for file in ~/Library/Preferences/*; do removeFile "$file"; done;
for file in ~/Library/PreferencePanes/*; do removeFile "$file"; done;
for file in ~/Library/Caches/*; do removeFile "$file"; done;

#FORGET FILES
pkgutil --pkgs / | grep -i "sangfor" | xargs -I{} sudo pkgutil --forget {}
pkgutil --pkgs / | grep -i "easyconnect" | xargs -I{} sudo pkgutil --forget {}

ps aux |grep -i 'sangfor' |grep -v 'grep' |awk '{print $2}' |xargs -I{} sudo kill {}
ps aux |grep -i 'easyconnect' |grep -v 'grep' |awk '{print $2}' |xargs -I{} sudo kill {}

echo "abcd" | pbcopy
rm -rf ~/abcd