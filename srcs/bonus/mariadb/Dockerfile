FROM debian:bookworm

RUN apt update -y 
RUN apt install -y mariadb-server

RUN sed -i 's/# port = 3306/port = 3306/' /etc/mysql/my.cnf
RUN sed -i 's/socket = \/run\/mysqld\/mysqld.sock/socket = \/var\/run\/mysqld\/mysqld.sock/' /etc/mysql/my.cnf
RUN sed -i 's/bind-address            = 127.0.0.1/bind-address            = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./script.sh /

RUN chmod +x /script.sh

ENTRYPOINT ["./script.sh"]
