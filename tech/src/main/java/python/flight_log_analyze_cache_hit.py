import datetime
import httplib
import json
import psycopg2
import re
import sys
import time
from dateutil import tz
from elasticsearch import Elasticsearch

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
if len(sys.argv) > 1:
    checkdate = sys.argv[1]
    if not (re.search('\d{4}-\d{2}-\d{2}', checkdate)):
        printlog("invalid date arg:" + checkdate)
        printlog("process ended..................................")
        exit()
else:
    yesterday = datetime.date.today() - datetime.timedelta(days=1)
    checkdate = yesterday.strftime('%Y-%m-%d')

hitvisits = []
allvisits = []

printlog("operation date:" + checkdate)

startime = datetime.datetime.strptime(checkdate + " 00:00:00.000", "%Y-%m-%d %H:%M:%S.%f")
startime = long(time.mktime(startime.timetuple()) * 1000.0 + startime.microsecond / 1000.0)
endtime = datetime.datetime.strptime(checkdate + " 23:59:59.999", "%Y-%m-%d %H:%M:%S.%f")
endtime = long(time.mktime(endtime.timetuple()) * 1000.0 + endtime.microsecond / 1000.0)

es = Elasticsearch([{'host': esHost, 'port': esPort}])

# hits
bodyData = {"query":{"bool":{"must":[{"query_string":{"query":"\"av search result using cache:\"", "analyze_wildcard":True}}, {"range":{"@timestamp":{"gte":startime, "lte":endtime, "format":"epoch_millis"}}}], "must_not":[]}}}
result = es.search(index='logstash-*', request_timeout=300, timeout='20m', _source=True, scroll='20m', size=2000, body=bodyData)  

curhits = result["hits"]["hits"]
scrollId = result["_scroll_id"]
hits = []
hits.extend(curhits)
printlog("cache hit search length:" + str(len(curhits)))

while len(curhits) == 2000:
    result = es.scroll(scroll_id=scrollId, request_timeout=300, scroll='20m')
    scrollId = result["_scroll_id"]
    curhits = result["hits"]["hits"]
    printlog("cache hit scrolled length:" + str(len(curhits)))
    hits.extend(curhits)

for hit in hits:
    localtime = datetime.datetime.strptime(hit["_source"]["@timestamp"], '%Y-%m-%dT%H:%M:%S.%fZ').replace(tzinfo=tz.tzutc()).astimezone(tz.tzlocal())
    line = str(localtime) + hit["_source"]["message"]
    match = re.search('\[(.{1,})\]', line)
    fields = []
    fields.append(line[0:16])
    fields.append(match.group(1).split(":")[0] + ':' + match.group(1).split(":")[1])
    fields.append(match.group(1).split(":")[2])
    hitvisits.append(fields)


# all
bodyData = {"query":{"bool":{"must":[{"query_string":{"query":"\"av route cahce search params, departure\"", "analyze_wildcard":True}}, {"range":{"@timestamp":{"gte":startime, "lte":endtime, "format":"epoch_millis"}}}], "must_not":[]}}}
result = es.search(index='logstash-*', request_timeout=300, timeout='20m', _source=True, scroll='20m', size=2000, body=bodyData)

curhits = result["hits"]["hits"]
scrollId = result["_scroll_id"]
hits = []
hits.extend(curhits)
printlog("cache all search length:" + str(len(curhits)))

while len(curhits) == 2000:
    result = es.scroll(scroll_id=scrollId, request_timeout=300, scroll='20m')
    scrollId = result["_scroll_id"]
    curhits = result["hits"]["hits"]
    printlog("cache all scrolled length:" + str(len(curhits)))
    hits.extend(curhits)

for hit in hits:
    localtime = datetime.datetime.strptime(hit["_source"]["@timestamp"], '%Y-%m-%dT%H:%M:%S.%fZ').replace(tzinfo=tz.tzutc()).astimezone(tz.tzlocal())
    line = str(localtime) + hit["_source"]["message"]
    match = re.search('departure : (.{3}).{1,}arrive : (.{3}).{1,}departuredate : (.{10})', line)
    fields = []
    fields.append(line[0:16])
    fields.append(match.group(1) + ":" + match.group(2))
    fields.append(match.group(3))
    allvisits.append(fields)

printlog("start to connect postgresql")
conn = psycopg2.connect(host=pgHost, port=pgPort, database=pgDatabase, user=pgUser, password=pgPassword)
cur = conn.cursor()
cur.execute(
    "CREATE TABLE if not exists TEST_WLH_DOM_CACHE_CACHEHIT (time varchar(16), od varchar(7), departuredate varchar(10));")
cur.execute(
    "CREATE TABLE if not exists TEST_WLH_DOM_CACHE_ALLVISIT (time varchar(16), od varchar(7), departuredate varchar(10));")

cur.execute("DELETE FROM TEST_WLH_DOM_CACHE_ALLVISIT WHERE SUBSTR(time, 1 ,10)= %s", (checkdate,))
cur.execute("DELETE FROM TEST_WLH_DOM_CACHE_CACHEHIT WHERE SUBSTR(time, 1 ,10)= %s", (checkdate,))

for fields in hitvisits:
    cur.execute("INSERT INTO TEST_WLH_DOM_CACHE_CACHEHIT (time, od, departuredate) VALUES (%s, %s, %s)",
                (fields[0], fields[1], fields[2]))
for fields in allvisits:
    cur.execute("INSERT INTO TEST_WLH_DOM_CACHE_ALLVISIT (time, od, departuredate) VALUES (%s, %s, %s)",
                (fields[0], fields[1], fields[2]))

conn.commit()
cur.close()
conn.close()
printlog("TEST_WLH_DOM_CACHE_CACHEHIT:" + str(len(hitvisits)))
printlog("TEST_WLH_DOM_CACHE_ALLVISIT:" + str(len(allvisits)))

printlog("start to connect postgresql")
conn = psycopg2.connect(host=pgHost, port=pgPort, database=pgDatabase, user=pgUser, password=pgPassword)
cur = conn.cursor()

cur.execute("DELETE FROM TEST_WLH_DOM_CACHE_NOTHITCACHE V WHERE TO_DATE(V. TIME, 'yyyy-mm-dd') = %s;", (checkdate,))
cur.execute("DELETE FROM TEST_WLH_DOM_CACHE_ANALYSIS WHERE CHECKDATE = %s;", (checkdate,))
cur.execute("INSERT INTO TEST_WLH_DOM_CACHE_NOTHITCACHE(TIME, OD, DEPARTUREDATE, KEYS) SELECT v.* FROM VIEW_TEST_WLH_ALLVISIT v WHERE 1 = 1 AND to_date(v. TIME, 'yyyy-mm-dd') = %s AND v.keyall NOT IN( SELECT DISTINCT h.keyhit FROM view_test_wlh_cachehit h WHERE 1 = 1 AND to_date(h. TIME, 'yyyy-mm-dd') = %s);", (checkdate,checkdate))
cur.execute("INSERT INTO TEST_WLH_DOM_CACHE_ANALYSIS SELECT %s, SUM(totalcounts), round( SUM(totalcounts) / SUM(totalcounts), 4) AS PERSENT_total, SUM(hitcounts), round( SUM(hitcounts) / SUM(totalcounts), 4) AS PERSENT_hit, SUM(notHitcounts), round( SUM(notHitcounts) / SUM(totalcounts), 4) AS PERSENT_nothit, SUM(notHitcountsNight), round( SUM(notHitcountsNight) / SUM(totalcounts), 4) AS PERSENT_nothitNight, SUM(notHitcountsAfterAweek), round( SUM(notHitcountsAfterAweek) / SUM(notHitcounts), 4) AS PERSENT_nothitAfterAweek, SUM(nothitcountsAfterAweekDay), round( SUM(nothitcountsAfterAweekDay) / SUM(notHitcounts), 4) AS PERSENT_nothitAfterAweekDay, SUM(countsAfterAweekDayNotInHot), round( SUM(countsAfterAweekDayNotInHot) / SUM(notHitcounts), 4) AS PERSENT_nothitNotInHot, SUM(EightToForteen), round( SUM(EightToForteen) / SUM(totalcounts), 4) AS PERSENT_nothitNotInHot FROM( SELECT totalcounts, 0 AS hitcounts, 0 AS notHitcounts, 0 AS notHitcountsNight, 0 AS notHitcountsAfterAweek, 0 AS nothitcountsAfterAweekDay, 0 AS countsAfterAweekDayNotInHot, 0 AS EightToForteen FROM( SELECT COUNT(v. TIME) AS totalcounts FROM TEST_WLH_DOM_CACHE_ALLVISIT v WHERE 1 = 1 AND to_date(v. TIME, 'yyyy-mm-dd') = %s) allvisit UNION SELECT 0, hitcounts, 0, 0, 0, 0, 0, 0 FROM( SELECT COUNT(h. TIME) AS hitcounts FROM TEST_WLH_DOM_CACHE_CACHEHIT h WHERE 1 = 1 AND to_date(h. TIME, 'yyyy-mm-dd') = %s) hitvisit UNION SELECT 0, 0, notHitcounts, 0, 0, 0, 0, 0 FROM( SELECT COUNT(n.OD) AS notHitcounts FROM TEST_WLH_DOM_CACHE_NOTHITCACHE n WHERE 1 = 1 AND to_date(n. TIME, 'yyyy-mm-dd') = %s) nothitvisit UNION SELECT 0, 0, 0, notHitcountsNight, 0, 0, 0, 0 FROM( SELECT COUNT(n.OD) AS notHitcountsNight FROM TEST_WLH_DOM_CACHE_notHITcache n WHERE 1 = 1 AND to_date(n. TIME, 'yyyy-mm-dd') = %s AND(n. TIME < to_char(to_timestamp(%s||' 08:00',  'yyyy-mm-dd HH24:MI'),'yyyy-mm-dd hh24:mi'))) notHitcountsNight UNION SELECT 0, 0, 0, 0, notHitcountsAfterAweek, 0, 0, 0 FROM( SELECT COUNT(n.DEPARTUREDATE) AS notHitcountsAfterAweek FROM TEST_WLH_DOM_CACHE_notHITcache n WHERE 1 = 1 AND to_date(n. TIME, 'yyyy-mm-dd') = %s AND to_char( to_date(n.DEPARTUREDATE, 'yyyy-mm-dd'), 'yyyy-mm-dd') > to_char( to_date(%s, 'yyyy-mm-dd') + 7, 'yyyy-mm-dd')) notHitcountsAfterAweek UNION SELECT 0, 0, 0, 0, 0, nothitcountsAfterAweekDay, 0, 0 FROM( SELECT COUNT(n.DEPARTUREDATE) AS nothitcountsAfterAweekDay FROM TEST_WLH_DOM_CACHE_notHITcache n WHERE 1 = 1 AND to_date(n. TIME, 'yyyy-mm-dd') = %s AND to_char( to_date(n.DEPARTUREDATE, 'yyyy-mm-dd'), 'yyyy-mm-dd') > to_char( to_date(%s, 'yyyy-mm-dd') + 7, 'yyyy-mm-dd') AND(n. TIME >= to_char(to_timestamp(%s||' 08:00',  'yyyy-mm-dd HH24:MI'),'yyyy-mm-dd hh24:mi'))) nothitcountsAfterAweekDay UNION SELECT 0, 0, 0, 0, 0, 0, countsAfterAweekDayNotInHot, 0 FROM( SELECT COUNT(n.DEPARTUREDATE) AS countsAfterAweekDayNotInHot FROM TEST_WLH_DOM_CACHE_notHITcache n WHERE 1 = 1 AND to_date(n. TIME, 'yyyy-mm-dd') = %s AND to_char( to_date(n.DEPARTUREDATE, 'yyyy-mm-dd'), 'yyyy-mm-dd') > to_char( to_date(%s, 'yyyy-mm-dd') + 7, 'yyyy-mm-dd') AND(n. TIME >= to_char(to_timestamp(%s||' 08:00',  'yyyy-mm-dd HH24:MI'),'yyyy-mm-dd hh24:mi')) AND n.OD NOT IN( SELECT DISTINCT h.OD FROM TEST_WLH_DOM_CACHE_cacheHIT h WHERE 1 = 1 AND to_date(h. TIME, 'yyyy-mm-dd') = %s)) countsAfterAweekDayNotInHot UNION SELECT 0, 0, 0, 0, 0, 0, 0, COUNT(OD) AS EightToForteen FROM TEST_WLH_DOM_CACHE_ALLVISIT v WHERE 1 = 1 AND to_date(v. TIME, 'yyyy-mm-dd') = %s AND to_char( to_date(v.DEPARTUREDATE, 'yyyy-mm-dd'), 'yyyy-mm-dd') > to_char( to_date(%s, 'yyyy-mm-dd') + 7, 'yyyy-mm-dd') AND to_char( to_date(v.DEPARTUREDATE, 'yyyy-mm-dd'), 'yyyy-mm-dd') <= to_char( to_date(%s, 'yyyy-mm-dd') + 14, 'yyyy-mm-dd')) sumall;", (checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate,checkdate))


conn.commit()
cur.close()
conn.close()

printlog("process ended..................................")
