FROM debian:bookworm

RUN apt update -y && apt install -y nginx && rm -rf /var/lib/apt/lists/*

COPY ./index.html /var/www/html/index.html
COPY ./nginx.conf /etc/nginx/sites-available/default

RUN ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
