curl --request POST --url http://192.168.10.16:7100/endpoints --header 'Version: 1.0' --header 'Content-Type: application/json' --data '{"label":"根据手机号或者卡号查询会员可用权益","method":"GET","module":"预约模块","name":"根据手机号或者卡号查询会员可用权益","path":"/desk/admin/appointments/members/*","plat":2}'
curl --request POST --url http://192.168.10.16:7100/endpoints --header 'Version: 1.0' --header 'Content-Type: application/json' --data '{"label":"根据站点名称查询站厅","method":"GET","module":"预约模块","name":"根据站点名称查询站厅","path":"/desk/admin/appointments/halls/*","plat":2}'