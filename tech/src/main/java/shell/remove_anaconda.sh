#!/bin/bash

ps aux |grep -i 'anaconda' |grep -v 'grep' |awk '{print $2}' |xargs -I{} sudo kill {}
ps aux |grep -i 'continuum' |grep -v 'grep' |awk '{print $2}' |xargs -I{} sudo kill {}

function removeFile(){
    if `echo "$1" | grep -qi "anaconda"` || `echo "$1" | grep -qi "continuum"`
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

sudo rm -rf "/opt/anaconda3";
sudo rm -rf "$HOME/opt/anaconda3";
sudo rm -rf "/opt/anaconda2";
sudo rm -rf "$HOME/opt/anaconda2";
sudo rm -rf "$HOME/.conda";
sudo rm -rf "$HOME/.anaconda";

#FORGET FILES
pkgutil --pkgs / | grep -i "anaconda" | xargs -I{} sudo pkgutil --forget {}
pkgutil --pkgs / | grep -i "continuum" | xargs -I{} sudo pkgutil --forget {}

echo "abcd" | pbcopy
rm -rf ~/abcd