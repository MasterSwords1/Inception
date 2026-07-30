FROM debian:bookworm

ARG WORDPRESS_USER

RUN apt update -y
RUN apt install -y curl \
	lsb-release apt-transport-https ca-certificates wget zip ssh mariadb-client

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" \
	| tee /etc/apt/sources.list.d/php.list

RUN apt update -y && apt install -y php php-mysql php-curl php-json \
	php-xml php-mbstring php-fpm && curl -O \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN groupadd $WORDPRESS_USER && useradd -g $WORDPRESS_USER $WORDPRESS_USER \
	&& mkdir -p /var/www/wordpress \
	&& chown -R $WORDPRESS_USER:$WORDPRESS_USER /var/www/wordpress \
	&& mkdir -p /home/$WORDPRESS_USER/ \
	&& chown -R $WORDPRESS_USER:$WORDPRESS_USER /home/$WORDPRESS_USER/

RUN sed -i 's/;daemonize = yes/daemonize = yes/' /etc/php/8.4/fpm/php-fpm.conf

RUN sed -i "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 0.0.0.0/" /etc/php/8.4/fpm/pool.d/www.conf
RUN sed -i "s/listen = \/run\/php\/php8.4-fpm.sock/listen = \/var\/run\/php\/php8.4-fpm.sock/" /etc/php/8.4/fpm/pool.d/www.conf

COPY ./script.sh /

COPY ./wp_pool.conf /etc/php/8.4/fpm/pool.d/wordpress_pool.conf

RUN chmod +x ./script.sh

ENTRYPOINT ["./script.sh"]
