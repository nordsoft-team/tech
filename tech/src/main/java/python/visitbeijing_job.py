# SADD SPOTS:FLOW:SIDS 703 704 705 706 707 708 751 753 756 758 760 761 762 763 764 766 767 769 770 773 777 778 779 780 783 805 806 807 808 809 810 815 816 817 818 819 820 821 822 823
# SET SPOTS:FLOW:SIDS:HEAT '[{"sid":"703","name":"八达岭","longitude":"116.024067","latitude":"40.362639","count":"50"},{"sid":"704","name":"八大处","longitude":"116.190196","latitude":"39.968527","count":"50"},{"sid":"705","name":"香山、植物园","longitude":"116.195044","latitude":"39.996194","count":"50"},{"sid":"706","name":"颐和园","longitude":"116.278749","latitude":"40.004869","count":"50"},{"sid":"707","name":"故宫","longitude":"116.403414","latitude":"39.924091","count":"50"},{"sid":"708","name":"世界公园","longitude":"116.293994","latitude":"39.816772","count":"50"},{"sid":"751","name":"天坛公园","longitude":"116.417246","latitude":"39.888243","count":"50"},{"sid":"753","name":"红螺寺","longitude":"116.634066","latitude":"40.389444","count":"50"},{"sid":"756","name":"龙庆峡","longitude":"116.00825","latitude":"40.557933","count":"50"},{"sid":"758","name":"动物园","longitude":"116.343376","latitude":"39.947735","count":"50"},{"sid":"760","name":"国家体育场","longitude":"116.402359","latitude":"39.999763","count":"50"},{"sid":"761","name":"石景山游乐园","longitude":"116.215291","latitude":"39.917734","count":"50"},{"sid":"762","name":"慕田峪长城","longitude":"116.571611","latitude":"40.437442","count":"50"},{"sid":"763","name":"景山公园","longitude":"116.402818","latitude":"39.93227","count":"50"},{"sid":"764","name":"中山公园","longitude":"116.400582","latitude":"39.916702","count":"50"},{"sid":"766","name":"国家游泳中心","longitude":"116.396832","latitude":"39.999271","count":"50"},{"sid":"767","name":"北京海洋馆","longitude":"116.347542","latitude":"39.950277","count":"50"},{"sid":"769","name":"玉渊潭公园","longitude":"116.326526","latitude":"39.922467","count":"50"},{"sid":"770","name":"陶然亭景区","longitude":"116.388442","latitude":"39.88066","count":"50"},{"sid":"773","name":"紫竹院公园","longitude":"116.32483","latitude":"39.948437","count":"50"},{"sid":"777","name":"恭王府","longitude":"116.39255","latitude":"39.943627","count":"50"},{"sid":"778","name":"北京欢乐谷","longitude":"116.501366","latitude":"39.873848","count":"50"},{"sid":"779","name":"十三陵","longitude":"116.231846","latitude":"40.263544","count":"50"},{"sid":"780","name":"北宫森林公园","longitude":"116.12471","latitude":"39.871839","count":"50"},{"sid":"783","name":"北海公园","longitude":"116.39548","latitude":"39.932909","count":"50"},{"sid":"805","name":"凤凰岭自然风景区","longitude":"116.091588","latitude":"40.112884","count":"50"},{"sid":"806","name":"朝阳公园","longitude":"116.489038","latitude":"39.949955","count":"50"},{"sid":"807","name":"龙潭湖公园","longitude":"116.444742","latitude":"39.885848","count":"50"},{"sid":"808","name":"圆明园遗址公园","longitude":"116.309804","latitude":"40.012658","count":"50"},{"sid":"809","name":"大观园公园","longitude":"116.362363","latitude":"39.875778","count":"50"},{"sid":"810","name":"地坛公园","longitude":"116.421358","latitude":"39.959903","count":"50"},{"sid":"815","name":"什刹海","longitude":"116.393981","latitude":"39.946208","count":"50"},{"sid":"816","name":"雍和宫","longitude":"116.423633","latitude":"39.953628","count":"50"},{"sid":"817","name":"云居寺","longitude":"115.781391","latitude":"39.615208","count":"50"},{"sid":"818","name":"潭柘寺","longitude":"116.03762","latitude":"39.91122","count":"50"},{"sid":"819","name":"水关长城","longitude":"116.043971","latitude":"40.341849","count":"50"},{"sid":"820","name":"居庸关","longitude":"116.079159","latitude":"40.296972","count":"50"},{"sid":"821","name":"世界花卉大观园","longitude":"116.359769","latitude":"39.840957","count":"50"},{"sid":"822","name":"雁栖湖","longitude":"116.673574","latitude":"40.398683","count":"50"},{"sid":"823","name":"奥林匹克森林公园","longitude":"116.396797","latitude":"40.025231","count":"50"}]'
# SET SPOTS:FLOW:SIDS:HEAT:MAP '{"1":"100","2":"90","3":"80","4":"70","5":"60"}'

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
