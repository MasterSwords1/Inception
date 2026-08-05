#!/bin/bash
set -e

if [ ! -f /etc/nginx/ssl/cert.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -keyout /etc/nginx/ssl/key.key \
        -out /etc/nginx/ssl/cert.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=${DOMAIN_NAME:-localhost}" \
        -addext "subjectAltName=DNS:localhost,DNS:42.ariyad.fr"
fi

rm -f /etc/nginx/sites-enabled/default

exec nginx -g "daemon off;"
