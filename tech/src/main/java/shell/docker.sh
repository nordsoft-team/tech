#1.建立exam网络
docker network create exam
#2.启动mysql容器
docker run --name mysql --network exam -p 3306:3306 -v mysql:/var/lib/mysql -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:8.0.23
#3.进入容器并建立exam数据库
docker exec -it mysql /bin/bash
#5.创建jar包volume并把jar复制进去
docker volume create jar
#6.启动项目容器
docker run --name jdk --network exam -p 8080:8080 -v jar:/root -d adoptopenjdk:11-jre-hotspot java -jar /root/exam-backend-0.0.1-SNAPSHOT.jar --spring.profiles.active=prod

#7.启动nginx
docker run --name nginx -p 80:80 -v angular:/usr/share/nginx/html -d nginx:1.18-alpine
