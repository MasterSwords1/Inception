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

sleep 2
mariadb -u root -e "CREATE DATABASE IF NOT EXISTS wordpress_db;"
mariadb -u root -e "CREATE USER IF NOT EXISTS '$WP_ADMIN'@'%' IDENTIFIED BY '$WP_ADMIN_PASS';" wordpress_db
mariadb -u root -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO '$WP_ADMIN'@'%';" wordpress_db
mariadb -u root -e "CREATE USER IF NOT EXISTS '$WP_USER'@'%' IDENTIFIED BY '$WP_USER_PASS';" wordpress_db
mariadb -u root -e "GRANT ALL PRIVILEGES ON wordpress_db.* TO '$WP_USER'@'%';" wordpress_db
service mariadb stop

mariadbd -u mysql
