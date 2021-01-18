#!/usr/bin/python
# -*- coding: UTF-8 -*-

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import Select
import time
import requests

# 进入登陆页面
chrome_options = Options()
# chrome_options.add_argument('--headless')
driver = webdriver.Chrome(options=chrome_options)
driver.get('http://101.200.240.249/site/login')

# 填写用户和密码
username = driver.find_element_by_id("loginform-username")
password = driver.find_element_by_id("loginform-password")
loginButton = driver.find_element_by_name("login-button")
username.send_keys("user1")
password.send_keys("password1")

# 点击登陆按钮
loginButton.submit()

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
    print("finish")
