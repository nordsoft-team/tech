#!/bin/bash

# SERVER USAGE
apt update
echo y| apt install git
cd ~
git init --bare myRep.git

# CLIENT USAGE
cd ~
git clone root@39.106.3.97:/root/myRep.git
cd ~/myRep
git pull
touch abcd.txt
git add .
git commit -m 'initial commit'
git push
