####################################本地项目准备
#1.后端项目打包
mvn package

#2.前端项目打包
ng build --prod


####################################远程项目准备
#1.建立exam网络
docker network create exam

#2.启动mysql容器
docker run --name mysql --network exam -v mysql:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:8.0.23
#3.进入容器并新建exam数据库
docker exec -it mysql /bin/bash

#4.创建jar卷并把本地后端jar复制过去
docker volume create jar
#5.启动项目容器
docker run --name jdk --network exam -v jar:/root -d adoptopenjdk:11-jre-hotspot java -jar /root/exam-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod

#6.创建angular卷并把本地前端dist复制过去
docker volume create angular
#7.启动nginx并把配置复制过去
docker run --name nginx --network exam -p 80:80 -p 443:443 -v angular:/usr/share/nginx/html -v nginx_conf:/etc/nginx -d nginx:1.18-alpine
