#!/bin/bash

apt install redis-server
redis-cli -h 127.0.0.1 -p 6379 -n 0
vi /etc/redis/redis.conf
/etc/init.d/redis-server restart