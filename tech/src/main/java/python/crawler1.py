#!/usr/bin/python
# -*- coding: UTF-8 -*-

from selenium import webdriver
from selenium.webdriver.chrome.options import Options
import json

# 进入登陆页面
chrome_options = Options()
chrome_options.add_argument('--headless')
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

cookies = driver.get_cookies()
fw = open('cookies.txt', 'w')
json.dump(cookies, fw)
fw.close()

driver.close()
print("test1 finished")
