# -*- coding: utf-8 -*-
import flask
import json
import redis
from flask import request
from flask import make_response

# SERVER CONFIG
host = '0.0.0.0'
port = 8888

# INTRANET REDIS
redisHost = '192.168.10.16'
redisPort = '6379'
redisPass = 'db490430abb8e9b38bf7dceff1de7e6950ba903f'
redisDb = '12'

# INTERNET REDIS
# redisHost='172.21.0.16'
# redisPort='6379'
# redisPass='112e670833c8736c'
# redisDb='2'

server = flask.Flask(__name__)
server.config['JSON_AS_ASCII'] = False


@server.route('/spots/info', methods=['get'])
def get_spots_info():
    r = redis.Redis(host=redisHost, port=redisPort, db=redisDb, password=redisPass)
    result = r.get('SPOTS:FLOW:SIDS:INFO:' + request.values.get('sid'));
    result = result if (result and result != '') else '{}'
    response = make_response(result)
    response.headers['Access-Control-Allow-Origin'] = '*'
    return  response

    
@server.route('/spots/level', methods=['get'])
def get_spots_level():
    r = redis.Redis(host=redisHost, port=redisPort, db=redisDb, password=redisPass)
    heat_result = r.get("SPOTS:FLOW:SIDS:HEAT");
    heat_map = r.get('SPOTS:FLOW:SIDS:HEAT:MAP')
    sid_infos = json.loads(heat_result)
    for sid_info in sid_infos:
        sid = sid_info["sid"]
        print (sid)
        r = redis.Redis(host=redisHost, port=redisPort, db=redisDb, password=redisPass)
        info_result = r.get('SPOTS:FLOW:SIDS:INFO:' + sid);
        level = json.loads(info_result)["ll"] if (info_result and info_result != '') else '' 
        sid_info["ll"] = int(level) if (level != '') else 1
        sid_info["count"] = json.loads(heat_map)[level] if (level != '') else 60 

    response = make_response(heat_result)
    response.headers['Access-Control-Allow-Origin'] = '*'
    return  response


if __name__ == '__main__':
    server.run(host=host, port=port)
