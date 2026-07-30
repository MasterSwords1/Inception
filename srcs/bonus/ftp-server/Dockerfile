FROM debian:bookworm

ARG FTP_USER
ARG FTP_USER_PASS

RUN apt update -y && apt install -y openssh-server

RUN service ssh stop

RUN sed -i "s/Subsystem	sftp	\/usr\/lib\/openssh\/sftp-server/Subsystem	sftp	\/usr\/lib\/openssh\/sftp-server -l VERBOSE/"\
		/etc/ssh/sshd_config

RUN addgroup ftp_users
RUN useradd -m $FTP_USER -g ftp_users

RUN echo "$FTP_USER:$FTP_USER_PASS" | chpasswd

RUN chmod 700 /home/$FTP_USER \
	&& mkdir /run/sshd && chmod 755 /run/sshd

COPY ./script.sh /
COPY ./my_ssh.conf /etc/sshd_config.f/my.conf

RUN chmod +x /script.sh

EXPOSE 22

ENTRYPOINT [ "./script.sh"]
