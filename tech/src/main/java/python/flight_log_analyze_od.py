import sys
import re
import psycopg2
import datetime
import time
import httplib
import json

def printlog(msg):
    print datetime.datetime.now().isoformat(), msg

printlog("process started..................................")
if len(sys.argv) > 1:
    checkdate = sys.argv[1]
    if not (re.search('\d{4}-\d{2}-\d{2}', checkdate)):
        printlog("invalid date arg:" + checkdate)
        printlog("process ended..................................")
        exit()
else:
    yesterday = datetime.date.today() - datetime.timedelta(days=1)
#     yesterday=datetime.date.today()
    checkdate = yesterday.strftime('%Y-%m-%d')

hitvisits = []
allvisits = []

conn = httplib.HTTPConnection("ls01.panatrip.cn:9200")
printlog("operation date:" + checkdate)

startime = datetime.datetime.strptime(checkdate + " 00:00:00.000", "%Y-%m-%d %H:%M:%S.%f")
startime = long(time.mktime(startime.timetuple()) * 1000.0 + startime.microsecond / 1000.0)
endtime = datetime.datetime.strptime(checkdate + " 23:59:59.999", "%Y-%m-%d %H:%M:%S.%f")
endtime = long(time.mktime(endtime.timetuple()) * 1000.0 + endtime.microsecond / 1000.0)

# data5={'query': {'filtered': {'query': {'bool': {'should': [{'query_string': {'query': "\"av_response save to\""}}]}},'filter': {'bool': {'must': [{'range': {'@timestamp': {'from': startime,'to': endtime}}},{'terms': {'tags.raw': ['etrip']}}]}}}},'highlight': {'fields': {},'fragment_size': 2147483647,'pre_tags': ['@start-highlight@'],'post_tags': ['@end-highlight@']},'size': 500,'sort': [{'@timestamp': {'order': 'desc','ignore_unmapped': 200}},{'@timestamp': {'order': 'desc','ignore_unmapped': 100}}]}
# print json.dumps(data5)
# bodyData = json.dumps(data5)
bodyData = json.dumps({"size":10000, "sort":[{"@timestamp":{"order":"desc", "unmapped_type":"boolean"}}], "query":{"filtered":{"query":{"query_string":{"analyze_wildcard":"true", "query":"\"av_response\""}}, "filter":{"bool":{"must":[{"range":{"@timestamp":{"gte":startime, "lte":endtime, "format":"epoch_millis"}}}], "must_not":[]}}}}, "aggs":{"2":{"date_histogram":{"field":"@timestamp", "interval":"30m", "time_zone":"Asia/Shanghai", "min_doc_count":0, "extended_bounds":{"min":startime, "max":endtime}}}}, "fields":["*", "_source"], "script_fields":{}, "fielddata_fields":["@timestamp"]})
conn.request(method="POST", url="/logstash-*/_search", body=bodyData)
r1 = conn.getresponse()
printlog(r1.status) 
printlog(r1.reason) 
hits = json.loads(r1.read())["hits"]["hits"]

for hit in hits:
#     localtime = datetime.datetime.strptime(hit["_source"]["@timestamp"], '%Y-%m-%dT%H:%M:%S.%fZ').replace(tzinfo=tz.tzutc()).astimezone(tz.tzlocal())
    line = hit["_source"]["message"]
    lineChild = line.split(":")[1]
    logarr = []
    logarr = lineChild.split("*")
    hitvisits.append(logarr)

conn.close()
printlog("start to connect postgresql")
conn = psycopg2.connect(
    "host=192.168.1.12 dbname=biqu  user=dev password=panatripdev")
cur = conn.cursor()
cur.execute('SET SEARCH_PATH = %s;', ('statistics',))
searchdate =''
departure_date=''
back_date=None
for logarr in hitvisits:
    if logarr[9].strip()!='':
        searchdate = datetime.datetime.strptime(logarr[9], "%Y%m%d%H%M%S")
    if logarr[2].strip()!='':
        departure_date = datetime.datetime.strptime(logarr[2], "%Y-%m-%d").date()
    if logarr[3].strip()!='':
        back_date = datetime.datetime.strptime(logarr[3], "%Y-%m-%d").date()
    cur.execute("INSERT INTO od_search (departure, arrive, departure_date,back_date,trip_type,adt_num,cnn_num,cabin_lev,is_international,search_date) VALUES (%s, %s, %s,%s, %s, %s,%s, %s, %s,%s)",
                (logarr[0], logarr[1], departure_date, back_date, logarr[4], logarr[5], logarr[6], logarr[7], logarr[8], searchdate))

conn.commit()
printlog("TEST_WLH_DOM_CACHE_ALLVISIT:" + str(len(allvisits)))
cur.close()
conn.close()
printlog("process ended..................................")
