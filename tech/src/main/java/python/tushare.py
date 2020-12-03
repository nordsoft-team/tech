# conda create -n test38 python=3.8 jupyter pandas -y
# pip install tushare
# https://waditu.com/
import tushare as ts
pro = ts.pro_api('2de4140def188bc0f9cf85e78b64cf07e58220db85286bbd019edb86')
df = pro.trade_cal(exchange='', start_date='20180901', end_date='20181001', fields='exchange,cal_date,is_open,pretrade_date', is_open='0')
df