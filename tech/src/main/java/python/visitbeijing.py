# -*- coding: utf-8 -*-
import flask
import json
import redis
from flask import request

# SERVER CONFIG
host = '0.0.0.0'
port = 8888

# INTRANET REDIS
redisHost = '192.168.10.16'
redisPort = '6379'
redisPass = 'db490430abb8e9b38bf7dceff1de7e6950ba903f'
redisDb = '12'

server = flask.Flask(__name__)
server.config['JSON_AS_ASCII'] = False


@server.route('/spots', methods=['get'])
def get_spots():
    r = redis.Redis(host=redisHost, port=redisPort, db=redisDb, password=redisPass)
    result = r.get('SPOTS:FLOW:LEVEL:' + request.values.get('sid'));
    return  result if result else '{}'
    

if __name__ == '__main__':
    server.run(host=host, port=port)
