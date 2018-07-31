import datetime
import httplib
import json
import psycopg2
import re
import sys
import time
from dateutil import tz

# INTRANET
# spiderHost = "localhost:8080"
# spiderUrl = '/1.0/spider/spiderCtrip?cityPairUrl=http://flights.ctrip.com/schedule/yie.bjs.html'
# spiderUrl = '/1.0/spider/spiderCtrip?cityPairUrl='
# INTERNET
spiderHost = "192.168.1.12:8940"
# spiderUrl = '/1.0/spider/spiderCtrip?cityPairUrl=http://flights.ctrip.com/schedule/yie.bjs.html'
spiderUrl = '/1.0/spider/spiderCtrip?cityPairUrl='

def printlog(msg):
    print datetime.datetime.now().isoformat(), msg

printlog("process started..................................")


conn = httplib.HTTPConnection(host=spiderHost, timeout=5)
# conn.request(method="GET", url="/1.0/spider/spiderCtrip?cityPairUrl=")
conn.request(method="GET", url=spiderUrl)
conn.close

printlog("process ended..................................")
