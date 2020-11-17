#!/bin/bash

cd /Applications
ls -al |grep "Python"
find . -maxdepth 1 -name "*Python*" -exec sudo rm -rf {} \;

cd /usr/local/bin
ls -al |grep "/Library/Frameworks/Python.framework"
ls -al |grep "/Library/Frameworks/Python.framework" |awk '{print $9}' |xargs -I{} echo {} |xargs -I{} sudo rm -rf {}

echo "/Library/Frameworks/Python.framework"
sudo rm -rf /Library/Frameworks/Python.framework

cd
echo "abcd" | pbcopy
rm -rf ~/abcd