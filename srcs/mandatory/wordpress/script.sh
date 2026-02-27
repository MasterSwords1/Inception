#!/bin/bash


if [ ! -f /var/run/php/php-fpm.sock ]; then
	touch /var/run/php/php-fpm.sock
fi


if ! wp core is-installed 2>/dev/null; then
	wp core download --path=/var/www/wordpress --allow-root
fi

sleep 10

wp config create \
  --path=/var/www/wordpress/ \
  --allow-root \
  --dbname=wordpress_db \
  --dbuser=$WP_ADMIN \
  --dbhost=mariadb \
  --dbpass=$WP_ADMIN_PASS \
  --force

wp option update home 'https://localhost:8080' --allow-root --path=/var/www/wordpress
wp option update siteurl 'https://localhost:8080' --allow-root --path=/var/www/wordpress

wp core install --path=/var/www/wordpress/ --allow-root --url='ariyad.42.fr' --title=WordPress --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=moulchi@example.com

service php8.4-fpm stop

php-fpm8.4 -F
