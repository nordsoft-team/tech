#!/bin/bash

cd /Applications
find . -maxdepth 1 -name "*Python*" -exec rm -rf {} \;

cd /usr/local/bin
ls -al |grep "/Library/Frameworks/Python.framework" |awk '{print $9}' |xargs -I{} sudo rm -rf {}

sudo rm -rf /Library/Frameworks/Python.framework

echo "abcd" | pbcopy
rm -rf ~/abcd