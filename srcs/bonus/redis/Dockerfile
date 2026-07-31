FROM debian:bookworm

RUN apt update -y && apt install -y redis-server && rm -rf /var/lib/apt/lists/*

RUN sed -i "s/# maxmemory <bytes>/maxmemory 128mb/" /etc/redis/redis.conf \
    && sed -i "s/^bind 127.0.0.1 -::1/bind 0.0.0.0/" /etc/redis/redis.conf \
    && sed -i "s/^protected-mode yes/protected-mode no/" /etc/redis/redis.conf \
    && sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/" /etc/redis/redis.conf

COPY ./script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

ENTRYPOINT ["script.sh"]
