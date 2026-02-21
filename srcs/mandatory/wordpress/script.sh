#!/bin/bash

if [[ $(ls -A /var/www/wordpress | wc -l) == "0" ]]; then
	su -c "wp core download --path=/var/www/wordpress --allow-root" - wordpress_user
fi

bash
