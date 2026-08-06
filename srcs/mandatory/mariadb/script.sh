#!/bin/bash
set -e

mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld
chown -R mysql:mysql /var/lib/mysql

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db

    mariadbd --user=mysql --datadir=/var/lib/mysql --skip-networking --socket=/run/mysqld/mysqld.sock &

    until mariadb --protocol=socket --socket=/run/mysqld/mysqld.sock -u root -e "SELECT 1" &>/dev/null; do
        sleep 1
    done

    mariadb --protocol=socket --socket=/run/mysqld/mysqld.sock -u root <<EOF
CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS '${WP_ADMIN}'@'%' IDENTIFIED BY '${WP_ADMIN_PASS}';
GRANT CREATE ON *.* TO '${WP_ADMIN}'@'%';
GRANT ALL PRIVILEGES ON wordpress_db.* TO '${WP_ADMIN}'@'%';
CREATE USER IF NOT EXISTS '${WP_USER}'@'%' IDENTIFIED BY '${WP_USER_PASS}';
GRANT ALL PRIVILEGES ON wordpress_db.* TO '${WP_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_ADMIN_PASS}';
FLUSH PRIVILEGES;
EOF

    mariadb-admin --protocol=socket --socket=/run/mysqld/mysqld.sock -u root -p"${WP_ADMIN_PASS}" shutdown
fi

exec mariadbd --user=mysql
