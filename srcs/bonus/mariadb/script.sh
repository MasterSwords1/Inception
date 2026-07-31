#!/bin/bash
set -e

# Secure runtime directory for PID/socket
mkdir -p /var/run/mysqld
chown -R mysql:mysql /var/run/mysqld

# Initialize database if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql --skip-test-db
    
    # Bootstrap setup using a temporary SQL file to prevent race conditions
    tmp_sql="/tmp/init.sql"
    cat << EOF > "$tmp_sql"
FLUSH PRIVILEGES;
CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS '${WP_ADMIN}'@'%' IDENTIFIED BY '${WP_ADMIN_PASS}';
GRANT ALL PRIVILEGES ON wordpress_db.* TO '${WP_ADMIN}'@'%';
CREATE USER IF NOT EXISTS '${WP_USER}'@'%' IDENTIFIED BY '${WP_USER_PASS}';
GRANT ALL PRIVILEGES ON wordpress_db.* TO '${WP_USER}'@'%';
ALTER USER 'root'@'localhost' IDENTIFIED BY '${WP_ADMIN_PASS}';
FLUSH PRIVILEGES;
EOF
    mariadbd --user=mysql --bootstrap < "$tmp_sql"
    rm -f "$tmp_sql"
fi

exec mariadbd --user=mysql
