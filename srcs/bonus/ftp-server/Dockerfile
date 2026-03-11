FROM debian:bookworm

RUN apt update -y && apt install -y vsftpd

RUN sed -i "s/anonymous_enable=YES/anonymous_enable=NO/g" /etc/vsftpd.conf
RUN sed -i "s/#write_enable=YES/write_enable=YES/g" /etc/vsftpd.conf
RUN sed -i "s/#chroot_local_user=YES/chroot_local_user=YES/g" /etc/vsftpd.conf
RUN echo "listen_port=2121" >> /etc/vsftpd.conf

RUN addgroup wp-filer
RUN useradd wp-filer -g wp-filer

RUN mkdir -p /home/wp-filer

RUN chown -R wp-filer:wp-filer /home/wp-filer

RUN usermod -d /home/wp-filer/ wp-filer

RUN echo 'wp-filer:sercer_pass' | chpasswd


ENTRYPOINT [ "vsftpd", "/etc/vsftpd.conf" ]
