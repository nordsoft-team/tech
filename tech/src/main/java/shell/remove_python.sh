#!/bin/bash

ls -al /Applications |grep "Python 3" |awk '{print $9}' |xargs -I{} rm -rf {}
ls -al /usr/local/bin |grep "/Library/Frameworks/Python.framework" |awk '{print $9}' |xargs -I{} rm -rf {}
rm -rf /Library/Frameworks/Python.framework

echo "abcd" | pbcopy
rm -rf ~/abcd