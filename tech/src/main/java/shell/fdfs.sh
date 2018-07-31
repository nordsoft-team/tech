#!/bin/bash
cd ~
ip=`curl http://www.pubyun.com/dyndns/getip`

apt update
echo y| apt install git

#INSTALL FDFS
cd ~
git clone https://github.com/happyfish100/libfastcommon.git
cd ~/libfastcommon/
echo y| apt install gcc
echo y| apt install make
./make.sh
./make.sh install

cd ~
git clone https://github.com/happyfish100/fastdfs.git
cd ~/fastdfs/
./make.sh
./make.sh install

#CONFIGURE FDFS
cd /etc/fdfs
cp client.conf.sample client.conf
cp storage.conf.sample storage.conf
cp tracker.conf.sample tracker.conf

mkdir -p /usr/fdfs_dir
sed -i "s;base_path=/home/yuqing/fastdfs;base_path=/usr/fdfs_dir;" tracker.conf
sed -i "s;base_path=/home/yuqing/fastdfs;base_path=/usr/fdfs_dir;" storage.conf
sed -i "s;store_path0=/home/yuqing/fastdfs;store_path0=/usr/fdfs_dir;" storage.conf
sed -i "s;tracker_server=192.168.209.121:22122;tracker_server=$ip:22122;" storage.conf
sed -i "s;base_path=/home/yuqing/fastdfs;base_path=/usr/fdfs_dir;" client.conf
sed -i "s;tracker_server=192.168.0.197:22122;tracker_server=$ip:22122;" client.conf


#START FDFS
/usr/bin/fdfs_trackerd /etc/fdfs/tracker.conf
/usr/bin/fdfs_storaged /etc/fdfs/storage.conf


sleep 10s

#INSTALL NGINX AND FDFS MODULE
cd ~
wget https://nginx.org/download/nginx-1.10.1.tar.gz
wget https://github.com/happyfish100/fastdfs-nginx-module/archive/master.zip

echo y| apt install unzip

unzip master.zip
tar -xf nginx-1.10.1.tar.gz


echo y| apt install  libpcre3 libpcre3-dev
echo y| apt install zlib1g-dev
echo y| apt install openssl libssl-dev

cd ~/nginx-1.10.1/
./configure --add-module=../fastdfs-nginx-module-master/src/
make
make install

/usr/local/nginx/sbin/nginx -V


#CONFIGURE FDFS MODULE
cp ~/fastdfs-nginx-module-master/src/mod_fastdfs.conf /etc/fdfs/
cd /etc/fdfs/

sed -i "s;tracker_server=tracker:22122;tracker_server=$ip:22122;" mod_fastdfs.conf
sed -i "s;url_have_group_name = false;url_have_group_name = true;" mod_fastdfs.conf
sed -i "s;store_path0=/home/yuqing/fastdfs;store_path0=/usr/fdfs_dir;" mod_fastdfs.conf


cd ~/fastdfs/conf
cp http.conf mime.types /etc/fdfs/

#CONFIGURE NGINX
cd /usr/local/nginx/conf
cp nginx.conf.default nginx.conf


sed -i "/error_page  404/i\  location /group1/M00 {" nginx.conf
sed -i "/error_page  404/i\      root /usr/fdfs_dir;" nginx.conf
sed -i "/error_page  404/i\      ngx_fastdfs_module;" nginx.conf
sed -i "/error_page  404/i\  }" nginx.conf


#START NGINX
/usr/local/nginx/sbin/nginx


#TEST
cd ~
touch abcd.txt
echo 'test' >> abcd.txt
/usr/bin/fdfs_upload_file /etc/fdfs/client.conf  abcd.txt
echo $ip
rm abcd.txt