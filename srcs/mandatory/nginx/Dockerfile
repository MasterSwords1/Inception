FROM debian:bookworm

RUN apt update -y && apt install -y nginx openssl

RUN mkdir -p /run/nginx /etc/nginx/ssl /var/www/wordpress

RUN chown -R www-data:www-data /var/www/wordpress

# RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old

COPY ./my-site.conf /etc/nginx/conf/

# RUN openssl req -new -newkey rsa:4096 -x509 -days 365 -nodes -out cert.crt \
# 	-subj "/C=US/ST=CA/L=SanFrancisco/O=LOL/CN=ariyad.42.fr" \
# 	-addext 'subjectAltName = DNS:ariyad.42.fr' -keyout key.key

CMD ["bash"]
