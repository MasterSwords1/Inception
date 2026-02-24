#!/bin/bash

mkdir -p /var/run/mysqld
touch /var/run/mysqld/mysqld.sock
touch /var/run/mysqld/mysqld.pid
touch /run/mysqld/mysqld.sock
touch /run/mysqld/mysqld.pid
chown -R mysql:root /var/run/mysqld/
chown -R mysql:root /run/mysqld/

# service mariadb start

mkdir mariadb-data 2&>/dev/null

if [[ $(ls -A /mariadb-data/ | wc -l) == "0" ]]; then
	mariadb-install-db --user=mysql --datadir=/mariadb-data 2&>/dev/null
fi

mariadb -u root < db-setup.sql

mariadbd-safe --skip-grant-tables --socket=/var/run/mysqld/mysqld.sock --bind-address=0.0.0.0
