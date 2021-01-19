#!/usr/bin/python
# -*- coding: UTF-8 -*-
import json
import os
import requests

# 读取cookies
fr = open('cookies.txt', 'r')
cookies = json.load(fr)
fr.close()

# 调用领取按钮请求
data = {'root_sku_id': '1030'}

cookies1 = {}
for cookie in cookies:
    cookies1[cookie['name']] = cookie['value']

res = requests.post(cookies=cookies1, url="http://101.200.240.249/artist/index", data=data)
print(res.json())
if res.json().get("status") == 200:
    os.system("say OK")

print("test2 finished")
