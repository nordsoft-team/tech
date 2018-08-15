#!/bin/bash

apt update
echo y| apt install mysql-server

# update user set host = '%' where user = 'root';
# grant all privileges on *.* to 'root'@'%' with grant option;
# flush privileges;
 
# cd /etc/mysql/mysql.conf.d/
# sed -i "s;bind-address;#bind-address;" mysqld.cnf
# /etc/init.d/mysql restart