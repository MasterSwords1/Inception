#!/bin/bash

sleep 30

if [ ! -f /var/run/php/php-fpm.sock ]; then
	touch /var/run/php/php-fpm.sock
fi

if ! wp core is-installed --path=/var/www/wordpress --allow-root; then
	wp core download --path=/var/www/wordpress --allow-root
fi

if [ ! -f /var/www/wordpress/wp-config.php ]; then

    wp config create \
    --path=/var/www/wordpress/ \
    --allow-root \
    --dbname=wordpress_db \
    --dbuser=$WP_ADMIN \
    --dbhost=mariadb \
    --dbpass=$WP_ADMIN_PASS
fi

wp core install --path=/var/www/wordpress/ --allow-root --url='https://localhost' --title=Inception --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=moulchi@example.com

wp option update home 'https://localhost' --allow-root --path=/var/www/wordpress
wp option update siteurl 'https://localhost' --allow-root --path=/var/www/wordpress

service php8.4-fpm stop

php-fpm8.4 -F
