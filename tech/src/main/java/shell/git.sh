#!/bin/bash

# SERVER USAGE
apt update
echo y| apt install git
adduser git
sed -i "s;git:x:1000:1000:,,,:/home/git:/bin/bash;git:x:1000:1000:,,,:/home/git:/bin/git-shell;" /etc/passwd
cd /home/git
git init --bare yue-demo.git

# CLIENT USAGE
cd ~
git clone git@39.106.3.97:/home/git/yue-demo.git
cd ~/yue-demo
git pull
touch abcd.txt
git add .
git commit -m 'initial commit'
git push
