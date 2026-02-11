wget wget https://wordpress.org/latest.zip && unzip latest.zip -d /var/www/ && rm latest.zip

groupadd wordpress

useradd -g wordpress wordpress_user
