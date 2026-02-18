FROM debian:bookworm

RUN apt update -y && apt install -y curl

RUN apt -y install lsb-release apt-transport-https ca-certificates wget zip

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" \
	| tee /etc/apt/sources.list.d/php.list

RUN apt update -y && apt install -y php php-mysql php-curl php-json \
	php-xml php-mbstring php-fpm && curl -O \
	https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN groupadd wordpress && useradd -g wordpress wordpress_user \
	&& mkdir -p /var/www/wordpress \
	&& chown -R wordpress_user:root /var/www/wordpress \
	&& mkdir -p /home/wordpress_user/.wp-cli/cache/

COPY ./script.sh /

RUN chmod +x ./script.sh
