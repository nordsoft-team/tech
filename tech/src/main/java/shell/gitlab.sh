#!/bin/bash

apt update
apt-get install -y curl openssh-server ca-certificates
apt-get install -y postfix
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash
apt-get install gitlab-ee
cd /etc/gitlab
cp gitlab.rb gitlab.rb.default
sed -i "s;external_url 'http://gitlab.example.com';external_url 'http://39.106.3.97';" gitlab.rb
gitlab-ctl reconfigure
#gitlab-ctl stop