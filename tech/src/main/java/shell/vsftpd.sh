#!/bin/bash
apt install vsftpd
mkdir  /srv/ftp/upload
chmod  777  /srv/ftp/upload

#local_umask=022
#anon_umask=022

#anon_mkdir_write_enable=YES
#anon_other_write_enable=YES