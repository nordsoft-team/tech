#!/usr/bin/python
# -*- coding: UTF-8 -*-
import os

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import Select
import time
import json

chrome_options = Options()
chrome_options.add_argument('--headless')
driver = webdriver.Chrome(options=chrome_options)
driver.get('http://101.200.240.249/site/login')

fr = open('cookies.txt', 'r')
cookies = json.load(fr)
fr.close()

for cookie in cookies:
    driver.add_cookie(cookie)

driver.get('http://101.200.240.249/artist/index')
# 进入首页点击下拉框选择
selectFaSku = driver.find_element_by_id("selectFaSku")

js = """ele = document.getElementById("selectFaSku").style.display="inline";"""
driver.execute_script(js)
Select(selectFaSku).select_by_index(3)

# 领取按钮可用时进行点击
time.sleep(2)
receiveButton = driver.find_element_by_class_name("drawDown")

if receiveButton.is_enabled():
    receiveButton.click()
    os.system("say OK")

driver.close()
print("test2 finished")
