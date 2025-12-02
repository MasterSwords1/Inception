FROM alpine:latest

RUN apk update

RUN apk --no-cache add nginx openssl

RUN mkdir -p /run/nginx /etc/nginx/ssl

# RUN mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.old

# COPY "./.conf" /etc/nginx/nginx.conf

RUN openssl req -new -newkey rsa:4096 -x509 -days 365 -nodes -out cert.crt \
	-subj "/C=US/ST=CA/L=SanFrancisco/O=LOL/CN=ariyad.42.fr" \
	-addext 'subjectAltName = DNS:ariyad.42.fr' -keyout key.key
