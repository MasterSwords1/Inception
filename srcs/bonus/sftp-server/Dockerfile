FROM debian:bookworm

RUN apt update -y && apt install -y openssh-server && rm -rf /var/lib/apt/lists/*

RUN mkdir /var/run/sshd

COPY ./script.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/script.sh

EXPOSE 22

ENTRYPOINT ["script.sh"]
