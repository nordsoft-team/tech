#!/usr/bin/python
# -*- coding: UTF-8 -*-

# pip install psycopg2
# conda install psycopg2




import psycopg2

connect = psycopg2.connect(database='postgres',
                           user='user',
                           password='',
                           port='5432'
                           )

cur = connect.cursor()
cur.execute('select version()')
results = cur.fetchall()
print(results)
