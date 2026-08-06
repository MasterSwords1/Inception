#!/bin/bash
set -e

echo "Waiting for MariaDB..."
until mariadb -h mariadb -u "${WP_ADMIN}" -p"${WP_ADMIN_PASS}" -e "SELECT 1;" &>/dev/null; do
    sleep 1
done
echo "MariaDB is online!"

cd /var/www/wordpress

if ! wp core is-installed --allow-root; then
    wp core download --allow-root
    wp config create \
        --allow-root \
        --dbname=wordpress_db \
        --dbuser="${WP_ADMIN}" \
        --dbhost=mariadb \
        --dbpass="${WP_ADMIN_PASS}"
    wp core install \
        --allow-root \
        --url="https://${DOMAIN_NAME:-localhost}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN}" \
        --admin_password="${WP_ADMIN_PASS}" \
        --admin_email="${WP_ADMIN_EMAIL:-admin@domain.com}"
fi

groupadd -f wordpress_user
id -u wordpress_user &>/dev/null || useradd -g wordpress_user wordpress_user
chown -R wordpress_user:wordpress_user /var/www/wordpress

exec php-fpm8.2 -F
