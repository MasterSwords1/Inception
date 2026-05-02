FROM debian:bookworm

RUN apt update -y && apt install -y nginx openssl

RUN mkdir -p /run/nginx /etc/nginx/ssl /var/www/wordpress

RUN chmod 755 /var/www/wordpress && chown -R www-data:www-data /var/www/wordpress

RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old

COPY ./nginx.conf /etc/nginx/nginx.conf

RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-keyout /etc/nginx/ssl/key.key \
	-out /etc/nginx/ssl/cert.crt \
	-subj "/C=US/ST=CA/L=SanFrancisco/O=LOL/CN=localhost" \
	-addext "subjectAltName=DNS:ariyad.42.fr,DNS:localhost"

COPY ./script.sh /

RUN chmod +x /script.sh

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

ENTRYPOINT ["./script.sh"]
