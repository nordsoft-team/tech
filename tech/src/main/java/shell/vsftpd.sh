#!/bin/bash
apt update
apt install vsftpd

cd /etc
cp vsftpd.conf vsftpd.conf.default

sed -i "s;anonymous_enable=NO;anonymous_enable=YES;" vsftpd.conf

echo 'local_umask=022' >> vsftpd.conf
echo 'anon_umask=022' >> vsftpd.conf

echo 'write_enable=YES' >> vsftpd.conf
echo 'anon_upload_enable=YES' >> vsftpd.conf
echo 'anon_mkdir_write_enable=YES' >> vsftpd.conf
echo 'anon_other_write_enable=YES' >> vsftpd.conf

/etc/init.d/vsftpd restart

mkdir  /srv/ftp/upload
chmod  777  /srv/ftp/upload
