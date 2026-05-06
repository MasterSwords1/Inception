FROM debian:bookworm

ARG FTP_USER
ARG FTP_USER_PASS

RUN apt update -y && apt install -y openssh-server

RUN service ssh stop

RUN sed -i "s/Subsystem	sftp	\/usr\/lib\/openssh\/sftp-server/Subsystem	sftp	\/usr\/lib\/openssh\/sftp-server -l VERBOSE/"\
		/etc/ssh/sshd_config

# RUN sed -i 's/#HostKey \/home\/ssh_host_rsa_key/HostKey \/home\/ssh_host_rsa_key/' /etc/ssh/sshd_config
# RUN sed -i 's/#HostKey \/home\/ssh_host_ecdsa_key/HostKey \/home\/ssh_host_ecdsa_key/' /etc/ssh/sshd_config
# RUN sed -i 's/#HostKey \/home\/ssh_host_ed25519_key/HostKey \/home\/ssh_host_ed25519_key/' /etc/ssh/sshd_config

RUN addgroup ftp_users
RUN useradd -m $FTP_USER -g ftp_users

# RUN usermod -d /home/wp-filer/ wp-filer

RUN echo "$FTP_USER:$FTP_USER_PASS" | chpasswd

RUN chmod 700 /home/$FTP_USER \
	&& mkdir /run/sshd && chmod 755 /run/sshd

COPY ./script.sh /
COPY ./my_ssh.conf /etc/sshd_config.f/my.conf

RUN chmod +x /script.sh

ENTRYPOINT [ "./script.sh"]
