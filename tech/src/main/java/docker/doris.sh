# 官网下载二进制文件，保存到如下目录，复制java-udf-jar-with-dependencies.jar到be/lib目录
# https://doris.apache.org/
/Users/fanfei/Documents/docker

# 下载镜像
docker pull apache/doris:build-env-ldb-toolchain-latest

# 启动FE
docker run -it -p 8030:8030 -p 9030:9030 -d --name=doris-fe -v /Users/fanfei/Documents/docker/apache-doris-fe-1.2.1-bin-x86_64:/opt/doris/fe apache/doris:build-env-ldb-toolchain-latest

# 配置FE
docker exec -it doris-fe /bin/bash
#/opt/doris/fe/conf/fe.conf priority_networks = 172.17.0.0/16

# 启动FE
/opt/doris/fe/bin/start_fe.sh --daemon

# 访问FE，账号root密码空
#http://localhost:8030

# 确认模块alive状态
show PROC '/frontends';

# 启动BE
docker run --privileged -it -d --name=doris-be -v /Users/fanfei/Documents/docker/apache-doris-be-1.2.1-bin-x86_64:/opt/doris/be apache/doris:build-env-ldb-toolchain-latest

# 配置BE
docker exec -it doris-be /bin/bash
#/opt/doris/be/conf/be.conf priority_networks = 172.17.0.0/16

# 启动BE
/opt/doris/be/bin/start_be.sh --daemon

# 访问FE
http://localhost:8030

# 增加节点，IP为BE的IP
ALTER SYSTEM ADD BACKEND "172.17.0.3:9050";

# 确认模块alive状态
show PROC '/backends';

# 通过MYSQL连接
mysql -h 127.0.0.1 -P9030 -uroot
# 建库建表确认正常
