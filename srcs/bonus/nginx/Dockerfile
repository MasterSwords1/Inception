FROM debian:bookworm

RUN apt update -y && apt install -y nginx openssl

RUN mkdir -p /run/nginx /etc/nginx/ssl /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

COPY ./wordpress.conf /etc/nginx/sites-enabled/wordpress

RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
	-keyout /etc/nginx/ssl/key.key \
	-out /etc/nginx/ssl/cert.crt \
	-subj "/C=US/ST=CA/L=SanFrancisco/O=LOL/CN=ariyad.42.fr" \
	-addext "subjectAltName=DNS:ariyad.42.fr,DNS:localhost"

COPY ./script.sh /

RUN chmod +x /script.sh

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 443

CMD ["./script.sh"]
