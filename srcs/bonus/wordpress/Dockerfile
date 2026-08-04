FROM debian:bookworm

ARG WORDPRESS_USER=wordpress_user

RUN apt update -y && apt install -y \
    curl \
    mariadb-client \
    php-fpm \
    php-mysql \
    php-curl \
    php-json \
    php-xml \
    php-mbstring \
    php-redis \
    libfcgi-bin \
    && rm -rf /var/log/apt/* /var/lib/apt/lists/*

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

RUN groupadd -f $WORDPRESS_USER && id -u $WORDPRESS_USER &>/dev/null || useradd -g $WORDPRESS_USER $WORDPRESS_USER \
    && mkdir -p /var/www/wordpress /run/php

RUN rm -f /etc/php/8.2/fpm/pool.d/www.conf

COPY ./wp_pool.conf /etc/php/8.2/fpm/pool.d/wordpress_pool.conf
COPY ./script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["script.sh"]
