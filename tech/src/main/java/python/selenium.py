from selenium import webdriver
# https://chromedriver.chromium.org/downloads
browser = webdriver.Chrome()
# browser = webdriver.Firefox()
browser.get("https://www.baidu.com/")
print(browser.page_source)
browser.close()
