# -*- coding: utf-8 -*-
import flask, json
from flask import request

server = flask.Flask(__name__)
server.config['JSON_AS_ASCII'] = False
@server.route('/login', methods=['get', 'post'])
def login():
    username = request.values.get('name')
    pwd = request.values.get('pwd')
    if username and pwd:
        if username=='xiaoming' and pwd=='111':
            resu = {'code': 200, 'message': '登录成功'}
            return json.dumps(resu, ensure_ascii=False)
        else:
            resu = {'code': -1, 'message': '账号密码错误'}
            return json.dumps(resu, ensure_ascii=False)
    else:
        resu = {'code': 10001, 'message': '参数不能为空！'}
        return json.dumps(resu, ensure_ascii=False)

if __name__ == '__main__':
    server.run(debug=False, port=8888, host='0.0.0.0')