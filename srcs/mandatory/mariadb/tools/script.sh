#!/bin/bash

mkdir -p /var/run/mysqld
touch /var/run/mysqld/mysqld.sock
touch /var/run/mysqld/mysqld.pid
chown -R mysql:root /var/run/mysqld/
chown -R mysql:root /run/mysqld/


mkdir mariadb-data 2&>/dev/null

if [[ $(ls -A /mariadb-data/ | wc -l) == "0" ]]; then
	mariadb-install-db --user=mysql --datadir=/mariadb-data 2&>/dev/null
fi

service mariadb start

mariadb -u root < db-setup.sql

service mariadb stop

mariadbd --socket=/var/run/mysqld/mysqld.sock --bind-address=0.0.0.0
