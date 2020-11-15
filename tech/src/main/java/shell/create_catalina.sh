#!/bin/bash

sudo pwd
hdiutil create -size 10240M ~/Desktop/Install\ macOS\ Catalina -ov -layout SPUD -fs HFS+J
hdiutil attach ~/Desktop/Install\ macOS\ Catalina.dmg -noverify -mountpoint /Volumes/Install\ macOS\ Catalina
sudo /Applications/Install\ macOS\ Catalina.app/Contents/Resources/createinstallmedia --volume /Volumes/Install\ macOS\ Catalina --nointeraction
hdiutil detach /Volumes/Install\ macOS\ Catalina
hdiutil convert -ov ~/Desktop/Install\ macOS\ Catalina.dmg -format UDTO -o ~/Desktop/Install\ macOS\ Catalina