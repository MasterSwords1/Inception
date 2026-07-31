FROM debian:bookworm

ARG WORDPRESS_USER=wordpress_user

# Install native PHP 8.2 packages & wget
RUN apt update -y && apt install -y \
    curl \
    wget \
    php-fpm \
    php-mysql \
    php-curl \
    php-json \
    php-xml \
    php-mbstring \
    && rm -rf /var/log/apt/* /var/lib/apt/lists/*

# Add wordpress system user and prepare directories
RUN groupadd -f $WORDPRESS_USER && id -u $WORDPRESS_USER &>/dev/null || useradd -g $WORDPRESS_USER $WORDPRESS_USER \
    && mkdir -p /var/www/wordpress /run/php

# Delete default www pool to prevent duplication/overhead
RUN rm -f /etc/php/8.2/fpm/pool.d/www.conf

COPY ./wp_pool.conf /etc/php/8.2/fpm/pool.d/wordpress_pool.conf
COPY ./script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["script.sh"]
