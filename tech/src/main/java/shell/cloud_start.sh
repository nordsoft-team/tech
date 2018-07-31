#!/bin/bash
cd ~/Documents/git/springCloud
git pull

cd ~/Documents/git/springCloud/cloudServer
mvn clean package

cd ~/Documents/git/springCloud/cloudProvider
mvn clean package

cd ~/Documents/git/springCloud/cloudConsumer
mvn clean package

cd ~/Documents/git/springCloud/cloudGateway
mvn clean package


cd ~

echo 'starting cloudServer'
nohup java -jar ~/Documents/git/springCloud/cloudServer/target/cloudServer-0.0.1-SNAPSHOT.jar --server.port=9901 >> ~/Documents/git/springCloud/cloudServer/cloudServer9901.log &
sleep 10
nohup java -jar ~/Documents/git/springCloud/cloudServer/target/cloudServer-0.0.1-SNAPSHOT.jar --server.port=9902 >> ~/Documents/git/springCloud/cloudServer/cloudServer9902.log &
sleep 10


echo 'starting cloudProvider'
nohup java -jar ~/Documents/git/springCloud/cloudProvider/target/cloudProvider-0.0.1-SNAPSHOT.jar --server.port=8801 >> ~/Documents/git/springCloud/cloudServer/cloudProvider8801.log &
sleep 10
nohup java -jar ~/Documents/git/springCloud/cloudProvider/target/cloudProvider-0.0.1-SNAPSHOT.jar --server.port=8802 >> ~/Documents/git/springCloud/cloudServer/cloudProvider8802.log &
sleep 10


echo 'starting cloudConsumer'
nohup java -jar ~/Documents/git/springCloud/cloudConsumer/target/cloudConsumer-0.0.1-SNAPSHOT.jar --server.port=7701>> ~/Documents/git/springCloud/cloudServer/cloudConsumer7701.log &
sleep 10
nohup java -jar ~/Documents/git/springCloud/cloudConsumer/target/cloudConsumer-0.0.1-SNAPSHOT.jar --server.port=7702>> ~/Documents/git/springCloud/cloudServer/cloudConsumer7702.log &
sleep 10


echo 'starting cloudGateway'
nohup java -jar ~/Documents/git/springCloud/cloudGateway/target/cloudGateway-0.0.1-SNAPSHOT.jar --server.port=6601 >> ~/Documents/git/springCloud/cloudServer/cloudGateway6601.log &
sleep 10