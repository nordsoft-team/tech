#!/bin/bash

apt update
echo y| apt install mysql-server
#cd /etc/mysql/mysql.conf.d/
#sed -i "s;bind-address;#bind-address;" mysqld.cnf
#/etc/init.d/mysql restart