import datetime
from dateutil import tz
import httplib
import json
import re
import sys
import time

from elasticsearch import Elasticsearch
import psycopg2


# CONFIGURATION START
esHost = "210.51.168.51"
esPort = "9200"
pgHost = "192.168.1.12"
pgPort = "5432"
pgDatabase = "biqu"
pgUser = "dev"
pgPassword = "panatripdev"
# CONFIGURATION END


def printlog(msg):
    print datetime.datetime.now().isoformat(), msg

printlog("process started..................................")
if len(sys.argv) == 3:
    checkdate1 = sys.argv[1]
    checkdate2 = sys.argv[2]
    if not (re.search('\d{4}-\d{2}-\d{2}', checkdate1)):
        printlog("invalid date arg:" + checkdate1)
        printlog("process ended..................................")
        exit()
    if not (re.search('\d{4}-\d{2}-\d{2}', checkdate2)):
        printlog("invalid date arg:" + checkdate2)
        printlog("process ended..................................")
        exit()
else:
    printlog("please input two date params..................................")
    exit()

hitvisits = []
allvisits = []

printlog("operation start date:" + checkdate1)
printlog("operation end date:" + checkdate2)

startime = datetime.datetime.strptime(checkdate1 + " 00:00:00.000", "%Y-%m-%d %H:%M:%S.%f")
startime = long(time.mktime(startime.timetuple()) * 1000.0 + startime.microsecond / 1000.0)
endtime = datetime.datetime.strptime(checkdate2 + " 23:59:59.999", "%Y-%m-%d %H:%M:%S.%f")
endtime = long(time.mktime(endtime.timetuple()) * 1000.0 + endtime.microsecond / 1000.0)

es = Elasticsearch([{'host': esHost, 'port': esPort}])

def fetchSize(airline):
    bodyData = {"query":{"bool":{"must":[{"query_string":{"query":"\"avSearch request param is \" && \"" + airline + "\"","analyze_wildcard":True}},{"match":{"APP_NAME":{"query":"biqu-bee","type":"phrase"}}},{"range":{"@timestamp":{"gte":startime,"lte":endtime,"format":"epoch_millis"}}}],"must_not":[]}}}
    result = es.count(index='logstash-*', request_timeout=300, body=bodyData)  
    printlog(airline + ":" + str(result["count"]))
    
for airline in ["MU", "HU", "MF", "SC", "GT", "UQ", "9H", "Y8", "PN", "FU", "3U", "8L", "GS", "JD", "HO"]:
    fetchSize(airline)

printlog("process ended..................................")
