mkdir -p /var/run/mysqld
touch /var/run/mysqld/mysqld.sock
touch /var/run/mysqld/mysqld.pid
chown -R mysql:mysql /var/run/mysqld/mysqld.sock
chown -R mysql:root /var/run/mysqld/

service mariadb start

mkdir mariadb-data

if [[ $(ls -A mariadb-data/ | wc -l) == "0" ]]; then
	mariadb-install-db --user=root --datadir=/mariadb-data
fi
