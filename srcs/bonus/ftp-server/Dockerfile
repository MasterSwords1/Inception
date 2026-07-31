FROM debian:bookworm

RUN apt update -y && apt install -y vsftpd && rm -rf /var/lib/apt/lists/*

COPY ./vsftpd.conf /etc/vsftpd.conf
COPY ./script.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/script.sh

EXPOSE 21 40000-40010

ENTRYPOINT ["script.sh"]
