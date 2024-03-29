#!/usr/bin/python
# -*- coding: UTF-8 -*-

# pip install pymysql
# conda install pymysql




import pymysql

# 打开数据库连接
db = pymysql.connect(host="localhost", user="root", password="", database="mysql", charset="utf8")

# 使用cursor()方法获取操作游标
cursor = db.cursor()

# 使用execute方法执行SQL语句
cursor.execute("SELECT VERSION()")

# 使用 fetchone() 方法获取一条数据
data = cursor.fetchone()

print("Database version : %s " % data)

# 关闭数据库连接
db.close()
