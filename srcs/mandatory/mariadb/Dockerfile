FROM debian:bookworm

RUN apt update -y && apt install -y mariadb-server

RUN sed -i 's/# port = 3306/port = 3306/' /etc/mysql/my.cnf
RUN sed -i 's/socket = \/run\/mysqld\/mysqld.sock/socket = \/var\/run\/mysqld\/mysqld.sock/' /etc/mysql/my.cnf

COPY ./tools/script.sh /

COPY ./tools/mysqld.cnf /etc/mysql/conf.d/mysqld.cnf

COPY ./tools/db-setup.sql /

RUN chmod +x /script.sh

ENTRYPOINT ["./script.sh"]
