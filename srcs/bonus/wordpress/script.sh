#!/bin/bash

sleep 20

if [ ! -f /var/run/php/php-fpm.sock ]; then
	touch /var/run/php/php-fpm.sock
fi

wp core download --path=/var/www/wordpress --allow-root

if [ ! -f /var/www/wordpress/wp-config.php ]; then

    wp config create \
    --path=/var/www/wordpress/ \
    --allow-root \
    --dbname=wordpress_db \
    --dbuser=$WP_ADMIN \
    --dbhost=mariadb \
    --dbpass=$WP_ADMIN_PASS
fi

wp core install --path=/var/www/wordpress/ --allow-root --url='https://localhost:443' --title=WordPress --admin_user=$WP_ADMIN --admin_password=$WP_ADMIN_PASS --admin_email=moulchi@example.com

wp option update home 'https://localhost:443' --allow-root --path=/var/www/wordpress
wp option update siteurl 'https://localhost:443' --allow-root --path=/var/www/wordpress

wp plugin install redis-cache --activate --allow-root --path=/var/www/wordpress/

wp config set WP_REDIS_HOST "redis" --add --allow-root --path=/var/www/wordpress/
wp config set WP_REDIS_PORT 6379 --raw --add --allow-root --path=/var/www/wordpress/
wp config set WP_REDIS_TIMEOUT 1 --raw --add --allow-root --path=/var/www/wordpress/
wp config set WP_REDIS_READ_TIMEOUT 1 --raw --add --allow-root --path=/var/www/wordpress/
wp config set WP_REDIS_DATABASE 0 --allow-root --path=/var/www/wordpress/

chown -R wordpress_user:wordpress_user /var/www/wordpress

wp redis enable --allow-root --path=/var/www/wordpress

service php8.4-fpm stop

php-fpm8.4 -F
