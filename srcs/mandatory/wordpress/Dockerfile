FROM debian:bookworm

RUN apt update -y

RUN apt -y install lsb-release apt-transport-https ca-certificates wget zip

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg

RUN echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" \
	| tee /etc/apt/sources.list.d/php.list

RUN apt update -y && apt install -y php php-mysql php-curl php-json \
	php-xml php-mbstring php-fpm

RUN	mkdir -p /var/www/wordpress

ADD ./script.sh /

RUN chmod +x ./script.sh
