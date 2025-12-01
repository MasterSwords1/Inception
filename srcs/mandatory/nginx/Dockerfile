FROM alpine:latest

RUN apk update

RUN apk --no-cache add nginx openssl

RUN mkdir -p /run/nginx

RUN rc-update add nginx

RUN service nginx start

