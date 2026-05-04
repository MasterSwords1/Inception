#!/bin/bash

if [ ! -f /var/www/wordpress/adminer.php ]; then
	wget https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -O /var/www/wordpress/adminer.php
fi

service php8.4-fpm stop

php-fpm8.4 -F
