docker run --name mysql -p 3306:3306 -e MYSQL_ALLOW_EMPTY_PASSWORD=yes -d mysql:8.0.23
docker run --name jdk -p 8080:8080 -v exam-backend:/root -d openjdk:17-slim java -jar /root/exam-backend.jar
docker run --name nginx -p 80:80 -v exam-frontend:/usr/share/nginx/html -d nginx:1.18-alpine
