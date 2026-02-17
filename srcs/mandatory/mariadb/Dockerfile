FROM debian:bookworm

RUN apt update -y && apt install -y mariadb-server

# RUN mkdir -p /etc/apt/keyrings

# RUN curl -o /etc/apt/keyrings/mariadb-keyring.pgp \
# 	'https://mariadb.org/mariadb_release_signing_key.pgp'


# COPY ./tools/mariadb.sources /etc/apt/sources.list.d/
COPY ./tools/mysqld.conf /etc/mysql/conf.d/
COPY ./tools/script.sh /

RUN chmod +x /script.sh

# RUN apt install -y mariadb-server
