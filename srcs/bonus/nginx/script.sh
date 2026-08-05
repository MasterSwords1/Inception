#!/bin/bash
set -e

if [ ! -f /etc/nginx/ssl/cert.crt ]; then
    mkdir -p /etc/nginx/ssl
    
    cat << EOF > /tmp/openssl.conf
[req]
distinguished_name = req_distinguished_name
x509_extensions = v3_req
prompt = no

[req_distinguished_name]
C = FR
ST = IDF
L = Paris
O = 42
CN = ${DOMAIN_NAME:-localhost}

[v3_req]
keyUsage = keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1 = ${DOMAIN_NAME:-localhost}
DNS.2 = 42.ariyad.fr
EOF

    openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
        -keyout /etc/nginx/ssl/key.key \
        -out /etc/nginx/ssl/cert.crt \
        -config /tmp/openssl.conf
    
    rm /tmp/openssl.conf
fi

rm -f /etc/nginx/sites-enabled/default

exec nginx -g "daemon off;"
