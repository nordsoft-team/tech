#!/bin/bash

sudo pwd
hdiutil create -o /tmp/Install\ macOS\ Catalina -size 9G -layout SPUD -fs HFS+J
hdiutil attach /tmp/Install\ macOS\ Catalina.dmg -noverify -mountpoint /Volumes/Install\ macOS\ Catalina
sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/Install\ macOS\ Catalina --nointeraction
hdiutil detach /Volumes/Install\ macOS\ Catalina
rm -rf ~/Desktop/Install\ macOS\ Catalina.cdr
hdiutil convert /tmp/Install\ macOS\ Catalina.dmg -format UDTO -o ~/Desktop/Install\ macOS\ Catalina
rm /tmp/Install\ macOS\ Catalina.dmg