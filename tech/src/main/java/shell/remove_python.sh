#!/bin/bash

cd /Applications
find . -maxdepth 1 -name "*Python*" -exec sudo rm -rf {} \;

cd /usr/local/bin
ls -al |grep "/Library/Frameworks/Python.framework" |awk '{print $9}' |xargs -I{} sudo rm -rf {}

sudo rm -rf /Library/Frameworks/Python.framework

cd
echo "abcd" | pbcopy
rm -rf ~/abcd