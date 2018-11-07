#!/bin/bash

# SERVER USAGE
apt update
echo y| apt install git
sudo adduser git
mkdir /home/git/.ssh
touch /home/git/.ssh/authorized_keys
sed -i "s;git:x:1000:1000:,,,:/home/git:/bin/bash;git:x:1000:1000:,,,:/home/git:/usr/bin/git-shell;" /etc/passwd
cd /home/git
sudo git init --bare yue-demo.git
chown -R git:git yue-demo.git

# CLIENT USAGE
cd ~
git clone git@39.106.3.97:/home/git/yue-demo.git
cd ~/yue-demo
git pull
touch abcd.txt
git add .
git commit -m 'initial commit'
git push
