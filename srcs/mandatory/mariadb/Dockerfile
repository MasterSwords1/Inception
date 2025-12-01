FROM alpine:latest

RUN apk --no-cache add mariadb-server

RUN rc-update add mariadb.service

RUN mysql_secure_installation << EOF

