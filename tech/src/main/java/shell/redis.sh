#!/bin/bash

apt update
echo y| apt install redis-server
cd /etc/redis/
cp redis.conf redis.conf.default
sed -i "s;bind 127.0.0.1;#bind 127.0.0.1;" redis.conf
/etc/init.d/redis-server restart
#redis-cli -h 127.0.0.1 -p 6379 -n 0