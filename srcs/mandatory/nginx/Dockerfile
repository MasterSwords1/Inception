FROM debian:bookworm

RUN apt update -y && apt install -y nginx openssl && rm -rf /var/lib/apt/lists/*

COPY ./wordpress.conf /etc/nginx/sites-enabled/wordpress
COPY ./script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 443

ENTRYPOINT ["script.sh"]

