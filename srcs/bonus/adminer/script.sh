#!/bin/bash
set -e

if [ ! -f /var/www/wordpress/adminer.php ]; then
    wget https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -O /var/www/wordpress/adminer.php
    chown wordpress_user:wordpress_user /var/www/wordpress/adminer.php
fi

exec php-fpm8.2 -F
