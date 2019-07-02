# -*- coding: utf-8 -*-
import flask
import json
import redis
import urllib
import time
from flask import request

# INTRANET REDIS
redisHost = '192.168.10.16'
redisPort = '6379'
redisPass = 'db490430abb8e9b38bf7dceff1de7e6950ba903f'
redisDb = '12'

# INTERNET REDIS
# redisHost='172.21.0.16'
# redisPort='6379'
# redisPass='112e670833c8736c'
# redisDb='2'

r = redis.Redis(host=redisHost, port=redisPort, db=redisDb, password=redisPass)
sids = r.smembers("RAILWAY.JOURNEY.SPOTS:SIDS");
for sid in sids:
    body = ''
    try: 
        body = urllib.urlopen('http://s.visitbeijing.com.cn/index.php?m=content&c=flow&catid=26&sid=' + sid).read()
    except Exception, ex: 
        print (ex)
        continue
    
    key = 'RAILWAY.JOURNEY.SPOTS:SIDS:' + sid
    body = body[1:-1]
    print(key)
    print(body)
    r.set(key, body)
    time.sleep(1)
