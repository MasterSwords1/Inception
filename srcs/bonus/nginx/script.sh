#!/bin/bash
set -e

# Generate SSL certificate at runtime if missing
if [ ! -f /etc/nginx/ssl/cert.crt ]; then
    mkdir -p /etc/nginx/ssl
    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -keyout /etc/nginx/ssl/key.key \
        -out /etc/nginx/ssl/cert.crt \
        -subj "/C=FR/ST=IDF/L=Paris/O=42/CN=${DOMAIN_NAME:-localhost}"
fi

# Ensure default site is disabled to avoid port/host mapping conflicts
rm -f /etc/nginx/sites-enabled/default

# Run Nginx in foreground directly
exec nginx -g "daemon off;"
