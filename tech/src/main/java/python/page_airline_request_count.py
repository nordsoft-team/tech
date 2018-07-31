import sys
import re
import psycopg2
import datetime
import time
import httplib
import json
from dateutil import tz

esurl = 'ls01.panatrip.cn:9200'
#esurl = '192.168.1.12:9200'

def printlog(msg):
    print datetime.datetime.now().isoformat(), msg

def conSqlAndExe(hitvisits):
    printlog("start to connect postgresql")
    conn = psycopg2.connect(
        "host=192.168.1.12 dbname=biqu  user=dev password=panatripdev")
    cur = conn.cursor()
    cur.execute('SET SEARCH_PATH = %s;', ('statistics',))
    searchdate =None
    departure_date=None
    for logarr in hitvisits:
        try: 
            if logarr[0].strip()!='' and len(logarr[0])==19:
                searchdate = datetime.datetime.strptime(logarr[0], "%Y-%m-%d %H:%M:%S")
            if logarr[3].strip()!='' :
                departure_date = datetime.datetime.strptime(logarr[3], "%Y-%m-%d").date()    
            cur.execute("INSERT INTO airline_search (search_date,departure, arrive, departure_date,airline) VALUES (%s, %s, %s,%s, %s)",
                    (searchdate, logarr[1], logarr[2], departure_date,logarr[4] ))
        except Exception,ex: 
            print(logarr)
            print Exception,":",ex  
    conn.commit()
    cur.close()
    conn.close()

if len(sys.argv) > 1:
    checkdate = sys.argv[1]
    if not (re.search('\d{4}-\d{2}-\d{2}', checkdate)):
        printlog("invalid date arg:" + checkdate)
        printlog("process ended..................................")
        exit()
else:
    yesterday = datetime.date.today() - datetime.timedelta(days=0)
#    yesterday=datetime.date.today()
    checkdate = yesterday.strftime('%Y-%m-%d')

printlog("process started..................."+checkdate)
hitvisits = []

startime = datetime.datetime.strptime(checkdate + " 00:00:00.000", "%Y-%m-%d %H:%M:%S.%f")
startime = long(time.mktime(startime.timetuple()) * 1000.0 + startime.microsecond / 1000.0)
endtime = datetime.datetime.strptime(checkdate + " 01:00:00.000", "%Y-%m-%d %H:%M:%S.%f")
endtime = long(time.mktime(endtime.timetuple()) * 1000.0 + endtime.microsecond / 1000.0)


conn = httplib.HTTPConnection(esurl)

#bodyData = json.dumps({"size":10000,"query":{"filtered":{"query":{"query_string":{"analyze_wildcard":"true", "query":"\"avSearch request parma\""}}, "filter":{"bool":{"must":[{"range":{"@timestamp":{"gte":startime, "lte":endtime, "format":"epoch_millis"}}}], "must_not":[]}}}}, "aggs":{"2":{"date_histogram":{"field":"@timestamp", "interval":"30m", "time_zone":"Asia/Shanghai", "min_doc_count":0, "extended_bounds":{"min":startime, "max":endtime}}}}, "fields":["*", "_source"], "script_fields":{}, "fielddata_fields":["@timestamp"]})
#Specify app name
bodyData = json.dumps({"size":10000,"query":{"filtered":{"query":{"query_string":{"analyze_wildcard":"true", "query":"\"avSearch request parma\""}}, "filter":{"bool":{"must":[{"query": {"match": {"APP_NAME": {"query": "biqu-flight","type": "phrase"}}}},{"range":{"@timestamp":{"gte":startime, "lte":endtime, "format":"epoch_millis"}}}], "must_not":[]}}}}, "aggs":{"2":{"date_histogram":{"field":"@timestamp", "interval":"30m", "time_zone":"Asia/Shanghai", "min_doc_count":0, "extended_bounds":{"min":startime, "max":endtime}}}}, "fields":["*", "_source"], "script_fields":{}, "fielddata_fields":["@timestamp"]})
conn.request(method="POST", url="/logstash-*/_search?scroll=10m", body=bodyData)
r1 = conn.getresponse()
printlog(r1.status) 
printlog(r1.reason) 
readstr=r1.read()
_scroll_id = json.loads(readstr)["_scroll_id"]
hits = json.loads(readstr)["hits"]["hits"]
for hit in hits:
    localtime = datetime.datetime.strptime(hit["_source"]["@timestamp"], '%Y-%m-%dT%H:%M:%S.%fZ')
    localtime = datetime.datetime.strptime(hit["_source"]["@timestamp"], '%Y-%m-%dT%H:%M:%S.%fZ').replace(tzinfo=tz.tzutc()).astimezone(tz.tzlocal())
    reqTime = str(localtime).split(".")[0]
    line = hit["_source"]["message"]
    lineChild = line.split(":")[1]
    logarr = []
    logarr.append(reqTime)
    logarr.append(lineChild.split(",")[0])
    logarr.append(lineChild.split(",")[1])
    logarr.append(lineChild.split(",")[2])
    logarr.append(lineChild.split(",")[3])
    hitvisits.append(logarr)
conSqlAndExe(hitvisits)
conn.close()
printlog("first total index :" + str(len(hitvisits)))
printlog("first process ended..................................")

#when first result size=10000,it means have next page,we need send next request 
#of couse size<10000,does not send next request
if len(hitvisits)==10000 :
    count = 1 #init first while count=1,when count=0,then break while
    page = 1 #page number
    while (count != 0 ):
        page = page + 1
        nextHitVisits = []
        conn = httplib.HTTPConnection(esurl)
        bodyData = json.dumps({"scroll_id":_scroll_id,"scroll":'2m'})
        # print(bodyData)
        conn.request(method="POST", url="/_search/scroll",body=bodyData)
        r1 = conn.getresponse()
        printlog(r1.status) 
        printlog(r1.reason)
        nextread=r1.read()
        hitsNext = json.loads(nextread)["hits"]["hits"]
        # print(_scroll_id)
        for hit in hitsNext:
            localtime = datetime.datetime.strptime(hit["_source"]["@timestamp"], '%Y-%m-%dT%H:%M:%S.%fZ')
            reqTime = str(localtime).split(".")[0]
            line = hit["_source"]["message"]
            lineChild = line.split(":")[1]
            logarr = []
            logarr.append(reqTime)
            logarr.append(lineChild.split(",")[0])
            logarr.append(lineChild.split(",")[1])
            logarr.append(lineChild.split(",")[2])
            logarr.append(lineChild.split(",")[3])
            nextHitVisits.append(logarr)
        
        conSqlAndExe(nextHitVisits)
        conn.close()
        count = len(nextHitVisits)
        print(str(page) + " page size :" + str(len(nextHitVisits)))
    printlog("process ended..................................")
