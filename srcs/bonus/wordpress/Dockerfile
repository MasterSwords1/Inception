FROM debian:bookworm

RUN apt update -y && apt install -y curl \
	lsb-release apt-transport-https ca-certificates wget zip ssh mariadb-client

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" \
	| tee /etc/apt/sources.list.d/php.list

RUN apt update -y && apt install -y php php8.5-mysql php-mysql php-curl php-json \
	php-xml php-mbstring php-fpm php-redis && curl -O \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN groupadd wordpress_user && useradd -g wordpress_user wordpress_user \
	&& mkdir -p /var/www/wordpress \
	&& chown -R wordpress_user:wordpress_user /var/www/wordpress \
	&& mkdir -p /home/wordpress_user/ \
	&& chown -R wordpress_user:wordpress_user /home/wordpress_user/

RUN sed -i 's/;daemonize = yes/daemonize = yes/' /etc/php/8.4/fpm/php-fpm.conf

RUN sed -i "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 0.0.0.0/" /etc/php/8.4/fpm/pool.d/www.conf
RUN sed -i "s/listen = \/run\/php\/php8.4-fpm.sock/listen = \/var\/run\/php\/php8.4-fpm.sock/" /etc/php/8.4/fpm/pool.d/www.conf

COPY ./script.sh /

COPY ./wp_pool.conf /etc/php/8.4/fpm/pool.d/wordpress_pool.conf

RUN chmod +x ./script.sh

RUN wget https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php -O /var/www/wordpress/adminer.php

ENTRYPOINT ["./script.sh"]
