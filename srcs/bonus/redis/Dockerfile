FROM debian:bookworm

RUN apt -y update && apt install -y lsb-release curl gpg
RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

RUN chmod 644 /usr/share/keyrings/redis-archive-keyring.gpg
RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list

RUN apt update -y && apt install -y redis

RUN sed -i "s/# maxmemory <bytes>/maxmemory 128mb/" /etc/redis/redis.conf
RUN sed -i "s/^bind 127.0.0.1 -::1/bind 0.0.0.0/" /etc/redis/redis.conf
RUN sed -i "s/^protected-mode yes/protected-mode no/" /etc/redis/redis.conf
RUN sed -i "s/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/" /etc/redis/redis.conf

RUN ln -sf /dev/stdout /var/log/redis/redis-server.log

COPY ./script.sh /

RUN chmod +x ./script.sh

ENTRYPOINT [ "./script.sh" ]
