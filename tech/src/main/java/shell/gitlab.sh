#!/bin/bash

apt update
apt-get install -y curl openssh-server ca-certificates
apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
cd /etc/gitlab
cp gitlab.rb gitlab.rb.default
sed -i "s;EXTERNAL_URL="http://gitlab.example.com";EXTERNAL_URL="http://39.106.3.97";" gitlab.rb
gitlab-ctl reconfigure