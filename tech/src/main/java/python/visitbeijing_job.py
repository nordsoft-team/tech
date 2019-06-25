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

#SADD SPOTS:FLOW:SIDS 703 704 705 706 707 708 751 753 756 758 760 761 762 763 764 766 767 769 770 773 777 778 779 780 783 805 806 807 808 809 810 815 816 817 818 819 820 821 822 823
r = redis.Redis(host=redisHost, port=redisPort, db=redisDb, password=redisPass)
sids = r.smembers("SPOTS:FLOW:SIDS");
for sid in sids:
    body = ''
    try: 
        body = urllib.urlopen('http://s.visitbeijing.com.cn/index.php?m=content&c=flow&catid=26&sid=' + sid).read()
    except Exception, ex: 
        print (ex)
        continue
    
    key = 'SPOTS:FLOW:SIDS:INFO:' + sid
    body = body[1:-1]
    print (key)
    print (body)
    r.set('SPOTS:FLOW:SIDS:INFO:' + sid, body)
    time.sleep(1)
