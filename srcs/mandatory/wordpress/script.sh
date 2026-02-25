#!/bin/bash

if [ ! -f /var/run/php/php-fpm.sock ]; then
	touch /var/run/php/php-fpm.sock
fi

if ! wp core is-installed 2>/dev/null; then
	wp core download --path=/var/www/wordpress --allow-root
fi

if [ ! -f /var/www/wordpress/wp-config.php ]; then
	wp config create --path=/var/www/wordpress/ --allow-root --dbname=wordpress_db --dbuser=moulchi --dbhost=mariadb-dev --dbpass=moulchi-inc --force
fi

wp core install --path=/var/www/wordpress/ --allow-root --url='ariyad.42.fr' --title=WordPress --admin_user=moulchi --admin_password=moulchi-inc --admin_email=moulchi@example.com

bash
