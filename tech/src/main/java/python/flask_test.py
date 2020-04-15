import flask
import json
import redis
from flask import request
from flask import make_response

server = flask.Flask(__name__)
server.config['JSON_AS_ASCII'] = False


@server.route('/test', methods=['get'])
def process():
    id = request.values.get('id')
    response = make_response(json.dumps(id, ensure_ascii=False))
    response.headers['Access-Control-Allow-Origin'] = '*'
    return  response


if __name__ == '__main__':
    server.run(host='0.0.0.0', port=8801)
