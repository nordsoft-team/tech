####################################本地项目准备
#1.后端项目打包
mvn package

#2.前端项目打包
ng build --prod --base-href /exam/


####################################远程项目准备
#1.建立exam网络
docker network create exam

#2.启动mysql容器
docker run --name mysql --network exam -p 3306:3306 -v mysql:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:8.0.23
#3.进入容器并新建exam数据库
docker exec -it mysql /bin/bash

#4.创建jar卷并把本地后端jar复制过去
docker volume create jar
#5.启动项目容器
docker run --name jdk --network exam -p 8080:8080 -v jar:/root -d adoptopenjdk:11-jre-hotspot java -jar /root/exam-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod

#6.创建angular卷并把本地前端dist复制过去
docker volume create angular
#7.启动nginx
docker run --name nginx -p 80:80 -v angular:/usr/share/nginx/html -d nginx:1.18-alpine
#8.修改nginx配置
docker exec -it nginx /bin/sh
#9.重启nginx
docker restart nginx



