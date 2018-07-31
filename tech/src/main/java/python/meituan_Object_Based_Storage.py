# -*- coding: utf-8 -*-  
import datetime
import gzip
import json
import os
import re
import mssapi
from mssapi.s3.connection import S3Connection
from mssapi.s3.key import Key
import redis


# 全局配置
# 公司
aws_access_key_id = 'fa2348bcdab8468ca0f0be2c2ea90c81'
aws_secret_access_key = 'ad18c13cd8a44061b59012f25b0b69c0'
# 个人
# aws_access_key_id = 'd16cf1d4107b4656beacfd43bb673591'
# aws_secret_access_key = '863d110bbab444a4bd1e02323aa95ef0'
meituanHost = 'mtmss.com'
bucketName = "biqu-test"
redisHost = '192.168.1.12'
redisPort = '6379'
redisDb = '6'

        
# 建立连接池
def getPool():
    printlog("start getPool process.")
    pool = redis.ConnectionPool(host=redisHost, port=redisPort, db=redisDb)
    r = redis.StrictRedis(connection_pool=pool)
    printlog("end getPool process.")
    return r

# 压缩并写入文件
def zipFile(fileName, content):
    printlog("start zipFile process.")
    f = gzip.open(fileName, 'wb')  
    f.writelines(content)  
    f.close()
    printlog("end zipFile process.")

# 将文件上传到美团云
def uplodeFile(fileName):
    printlog("start uplodeFile process.")
    conn = S3Connection(
        aws_access_key_id=aws_access_key_id,
        aws_secret_access_key=aws_secret_access_key,
        host=meituanHost,
    )
    
    if(conn.lookup(bucketName) == None): 
        bucket = conn.create_bucket(bucketName)

    bucket = conn.get_bucket(bucketName)
    
    k1 = Key(bucket, fileName[:4] + "/" + fileName[:7] + "/" + fileName[:10] + "/" + fileName)
    headers = {}
    headers["Content-Type"] = "application/x-gzip"
    k1.set_contents_from_file(open(fileName, 'r+'), headers)
    
    conn.close()
    os.remove(fileName)
    printlog("end uplodeFile process.")

# 打印日志
def printlog(msg):
    print datetime.datetime.now().isoformat(), msg

# 添加多余航班信息到易购云
def addFlight(yeegoyunPrice, airlinePrice, yeegouyunPriceAirline):
    flightDifferenceKeys = set(airlinePrice.get(yeegouyunPriceAirline).keys()).difference(set(yeegoyunPrice.get(yeegouyunPriceAirline).keys()))
    for flightKey in flightDifferenceKeys:
        yeegoyunPrice.get(yeegouyunPriceAirline)[flightKey] = (airlinePrice.get(yeegouyunPriceAirline).get(flightKey))

# 添加多余航司信息到易购云
def addAirline(yeegoyunPrice, airlinePrice):
    airlineDifferenceKeys = set(airlinePrice.keys()).difference(set(yeegoyunPrice.keys()))
    for airlineKey in airlineDifferenceKeys:
        yeegoyunPrice[airlineKey] = airlinePrice.get(airlineKey)
        
# 附加舱位信息
def addCabin(dictCabin, odd, yeegoyunPrice):
    # 判断是否有舱位信息
    if dictCabin.has_key(odd + ':CABIN'):
        cabins = json.loads(dictCabin.get(odd + ':CABIN'))
    # 循环舱位信息到易购云
        for yeegouyunPriceAirline in yeegoyunPrice.keys():
            for cabinsAirline in cabins.keys():
                if yeegouyunPriceAirline == cabinsAirline:
                    for yeegouyunPriceAirlineFlight in yeegoyunPrice.get(yeegouyunPriceAirline).keys():
                        for cabinsAirlineFlight in cabins.get(yeegouyunPriceAirline).keys():
                            if re.match(cabinsAirlineFlight, yeegouyunPriceAirlineFlight):
                                segment = json.loads(yeegoyunPrice.get(yeegouyunPriceAirline).get(yeegouyunPriceAirlineFlight).get("segment"))
                                for seg in segment:
                                    for cabin in cabins.get(yeegouyunPriceAirline).get(cabinsAirlineFlight).keys():
                                        if seg["cabin"] == cabin:
                                            seg["cabinNum"] = cabins.get(yeegouyunPriceAirline).get(cabinsAirlineFlight).get(cabin)
                                            yeegoyunPrice.get(yeegouyunPriceAirline).get(yeegouyunPriceAirlineFlight)["cabinNum"] = seg["cabinNum"]
                                yeegoyunPrice.get(yeegouyunPriceAirline).get(yeegouyunPriceAirlineFlight)["segment"] = json.dumps(segment)
                                
printlog("process started..............")
# 获取连接池
r = getPool()

# 设定文件名
fileName = datetime.datetime.now().isoformat()[:10] + "_" + datetime.datetime.now().isoformat()[11:13] + ".gz"

# 无序且不重复出发地目的地日期
# CACHE:DLC:TSN:2016-08-04
oddSet = set()
dictPrice = {}
dictCabin = {}
newDictPrice = {}
p = r.pipeline(transaction=False)

# 取得所有键
p.keys("CACHE:*:PRICE*")
p.keys("CACHE:*:CABIN")
pipeRes = p.execute()

priceKeys = pipeRes[0]
cabinKeys = pipeRes[1]

# CACHE:DLC:TSN:2016-08-04
for key in priceKeys:
    oddSet.add(key[:24])

# CACHE:DLC:TSN:2016-08-04:PRICE:YEEGOYUN
p.mget(priceKeys)
# CACHE:DLC:TSN:2016-08-04:CABIN
p.mget(cabinKeys)
pipeRes = p.execute()

printlog("prepare for integrating pipeline result.")

for index in range(len(pipeRes[0])):
    dictPrice[priceKeys[index]] = pipeRes[0][index]
for index in range(len(pipeRes[1])):
    dictCabin[cabinKeys[index]] = pipeRes[1][index]



printlog("prepare for merging the data.")
# 循环每一个出发地目的地出发时间
for odd in oddSet:
    # 有YEEGOYUN时，合并各航司信息到YEEGOYUN
    if dictPrice.has_key(odd + ':PRICE:YEEGOYUN'):
        yeegoyunCache = json.loads(dictPrice.get(odd + ':PRICE:YEEGOYUN'))
        yeegoyunPrice = json.loads(yeegoyunCache.get("price")) 
        # 循环航司价格信息到易购云
        for priceKey in  priceKeys:
            if priceKey[:30] == odd + ':PRICE' and priceKey[:39] != odd + ':PRICE:YEEGOYUN':
                # 某个航司的价格缓存
                airlinePrice = json.loads(json.loads(dictPrice.get(priceKey)).get("price")) 
                for yeegouyunPriceAirline in yeegoyunPrice.keys():
                     for airlinePriceAirline in airlinePrice.keys():
                         if yeegouyunPriceAirline == airlinePriceAirline:
                             for yeegouyunPriceAirlineFlight in yeegoyunPrice.get(yeegouyunPriceAirline).keys():
                                 for airlinePriceAirlineFlight in airlinePrice.get(airlinePriceAirline).keys():
                                     if yeegouyunPriceAirlineFlight == airlinePriceAirlineFlight:
                                         hasWeb = False
                                         for priceObj1 in yeegoyunPrice.get(yeegouyunPriceAirline).get(yeegouyunPriceAirlineFlight)["prices"]:
                                             for priceObj2 in airlinePrice.get(yeegouyunPriceAirline).get(yeegouyunPriceAirlineFlight)["prices"]:
                                                 if priceObj1["name"] == "WEB" and priceObj2["name"] == "WEB":
                                                    priceObj1["price"] = priceObj2["price"]
                                                    priceObj1["source"] = priceObj2["source"]
                                                    hasWeb = True
                                                    break
                                         if not hasWeb:
                                            yeegoyunPrice.get(yeegouyunPriceAirline).get(yeegouyunPriceAirlineFlight)["prices"] .extend(airlinePrice.get(airlinePriceAirline).get(airlinePriceAirlineFlight)["prices"]) 
                             # 添加多余航班信息到易购云
                             addFlight(yeegoyunPrice, airlinePrice, yeegouyunPriceAirline)
                # 添加多余航司信息到易购云
                addAirline(yeegoyunPrice, airlinePrice)
        yeegoyunCache["price"] = json.dumps(yeegoyunPrice);
        
        # 附加舱位信息
        addCabin(dictCabin, odd, yeegoyunPrice)
        yeegoyunCache["price"] = json.dumps(yeegoyunPrice);
        newDictPrice[odd] = json.dumps(yeegoyunCache)
        
    # 没有YEEGOYUN时，合并各航司信息
    elif not dictPrice.has_key(odd + ':PRICE:YEEGOYUN'):
        yeegoyunCache = {}
        yeegoyunPrice = {}
        for priceKey in  priceKeys:
            if priceKey[:30] == odd + ':PRICE' and priceKey[:39] != odd + ':PRICE:YEEGOYUN':
                # 某个航司的价格缓存
                airlinePrice = json.loads(json.loads(dictPrice.get(priceKey)).get("price")) 
                for airlinePriceAirline in airlinePrice.keys():
                   yeegoyunPrice[airlinePriceAirline] = airlinePrice.get(airlinePriceAirline)
        yeegoyunCache["price"] = json.dumps(yeegoyunPrice);
        newDictPrice[odd] = json.dumps(yeegoyunCache)
        
        # 判断是否有舱位信息
        addCabin(dictCabin, odd, yeegoyunPrice)
        yeegoyunCache["price"] = json.dumps(yeegoyunPrice);
        newDictPrice[odd] = json.dumps(yeegoyunCache)

# 转换为新的格式
printlog("prepare for transforming to new format.")
finalObjs = []
for key in newDictPrice.keys():
    finalObj = {}
    finalObj["departure"] = key[6:9]
    finalObj["arrive"] = key[10:13]
    finalObj["departureDate"] = key[14:]
    finalObj["routekey"] = key[6:]
    finalObj["avTime"] = fileName[-18:-3]
    airlines = []
    priceJson = json.loads(json.loads(newDictPrice.get(key)).get("price"))
    for airline in priceJson.keys():
        addedFlight = []
        for flight in  priceJson.get(airline).keys():
            seg = json.loads(priceJson.get(airline).get(flight).get("segment"))[0]
            if not (seg["airline"] + seg["flightNo"]) in addedFlight:
                 airlinesObj = {}
                 addedFlight.append(seg["airline"] + seg["flightNo"])
                 airlinesObj["isFly"] = priceJson.get(airline).get(flight).get("isFly")
                 segments = []
                 segmentsObj = {}
                 seg = json.loads(priceJson.get(airline).get(flight).get("segment"))[0]
                 segmentsObj["depatureAirport"] = seg["depatureAirport"]
                 segmentsObj["arriveAirport"] = seg["arriveAirport"]
                 segmentsObj["depatureDate"] = seg["depatureDate"]
                 segmentsObj["depatureTime"] = seg["depatureTime"]
                 segmentsObj["arriveDate"] = seg["arriveDate"]
                 segmentsObj["arriveTime"] = seg["arriveTime"]
                 segmentsObj["airline"] = seg["airline"]
                 segmentsObj["flightNo"] = seg["flightNo"]
                 segmentsObj["stopQuantity"] = seg["stopQuantity"]
                 segmentsObj["hasMeal"] = seg["hasMeal"]
                 segmentsObj["flightType"] = seg["flightType"]
                 terminal = {}
                 terminal["dep"] = ""  if seg["terminal"] is None or seg["terminal"] == '' else json.loads(seg["terminal"])["dep"] 
                 terminal["arr"] = ""  if seg["terminal"] is None or seg["terminal"] == '' else json.loads(seg["terminal"])["arr"] 
                 segmentsObj["terminal"] = terminal
                 segmentsObj["flightTime"] = seg["flightTime"]
                 segmentsObj["fee"] = priceJson.get(airline).get(flight).get("adtFee")
                 segmentsObj["tax"] = priceJson.get(airline).get(flight).get("adtFax")
                 cabinObj = {}
                 cabinObj["cabin"] = seg["cabin"]
                 cabinObj["cabinNum"] = seg["cabinNum"]
                 cabinObj["cabinLev"] = priceJson.get(airline).get(flight).get("cabinLev")
                 cabinObj["prices"] = priceJson.get(airline).get(flight).get("prices")
                 segmentsObj["cabins"] = [cabinObj] 
                 segments.append(segmentsObj)
                 airlinesObj["segments"] = segments
                 airlines.append(airlinesObj)
            else:
                seg = json.loads(priceJson.get(airline).get(flight).get("segment"))[0]
                for airlinesObj in airlines:
                    for segmentsObj in airlinesObj["segments"]:
                        if re.match(segmentsObj["airline"] + segmentsObj["flightNo"], flight):
                             cabinObj = {}
                             cabinObj["cabin"] = seg["cabin"]
                             cabinObj["cabinNum"] = seg["cabinNum"]
                             cabinObj["cabinLev"] = priceJson.get(airline).get(flight).get("cabinLev")
                             cabinObj["prices"] = priceJson.get(airline).get(flight).get("prices")
                             segmentsObj["cabins"] .append(cabinObj) 

    finalObj["airlines"] = airlines
    finalObjs.append(finalObj)                
             
             
    
# 取得所有值
printlog("prepare for writing to file.")
content = []
for obj in finalObjs:
    content.append(json.dumps(obj, sort_keys=False) + "\n")

# 压缩成文件
zipFile(fileName, content)

# 上传文件
uplodeFile(fileName)
printlog("process ended..............")
