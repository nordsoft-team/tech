import sys
import re
import redis
import datetime
import dateutil

#INTRANET
# redisHost = '192.168.1.12'
# redisPort = '6379'
# redisDb = '6'

#INTERNET
# redisHost = '210.51.168.56'
redisHost = '192.168.1.211'
redisPort = '63930'
redisDb = '0'


def printlog(msg):
    print datetime.datetime.now().isoformat(), msg

printlog("process started..................................")
if len(sys.argv) > 1:
    startDate = sys.argv[1]
    if not (re.search('\d{4}-\d{2}-\d{2}', startDate)):
        printlog("invalid date arg:" + startDate)
        printlog("process ended..................................")
        exit()
else:
    sevenDaysLater = datetime.date.today() + datetime.timedelta(days=7)
    startDate = sevenDaysLater.strftime('%Y-%m-%d')

patterns = []
for index in range(0, 35):
    delDay = (datetime.date(int(startDate[0:4]), int(startDate[5:7]), int(startDate[8:])) + datetime.timedelta(days=index)).strftime('%Y-%m-%d')
    patterns.append('CACHE*' + delDay + "*")
for index in range(0, 12):
    delMonth = (datetime.date(int(delDay[0:4]), int(delDay[5:7]), int(delDay[8:])) + datetime.timedelta(days=28 * index)).strftime('%Y-%m-%d')
    patterns.append('CACHE*' + delMonth[0:7] + "*")



r = redis.Redis(host=redisHost, port=redisPort, db=redisDb)
for pattern in patterns:
    printlog("the pattern to be deleted: " + pattern)
    concretKeys = r.keys(pattern)
    count = 0
    for key in concretKeys:
        count += r.delete(key)

    printlog("deleted pattern count: " + str(count))

printlog("process ended..................................")
