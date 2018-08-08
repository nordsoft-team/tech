#!/bin/bash
apt update
echo y| apt install postgresql
cd /etc/postgresql/9.5/main/

cp postgresql.conf postgresql.conf.default
sed -i "s;#listen_addresses = 'localhost';listen_addresses = '*';" postgresql.conf

cp pg_hba.conf pg_hba.conf.default
echo "host  all  all  0.0.0.0 0.0.0.0  md5" >> pg_hba.conf
/etc/init.d/postgresql restart


sudo -u postgres psql<<EOF
	alter user postgres with password 'postgres';
	\q
EOF

#echo 'export LC_ALL=C'>>~/.bashrc
#psql -U postgres -d postgres -h 127.0.0.1 -p 5432