#!/bin/bash

apt update
echo y| apt install nginx

cd /etc/nginx/
cp nginx.conf nginx.conf.default


#server {
#        listen			80;
#        server_name		www.fanfei.tech;
#
#        location / {
#            root		/srv/ftp;
#            autoindex	on;
#
#        }
#}


# /var/www/html