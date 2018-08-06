#!/bin/bash
apt install vsftpd
mkdir  /srv/ftp/upload
chmod  777  /srv/ftp/upload
# cat /etc/vsftpd.conf anon_umask=022