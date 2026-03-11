FROM debian:bookworm

RUN apt update -y && apt install -y openssh-server

# RUN sed -i "s/#HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/g" /etc/ssh/sshd_config
# RUN sed -i "s/X11Forwarding yes/X11Forwarding no/g" /etc/ssh/sshd_config
# RUN sed -i "s/#LoginGraceTime 2m/LoginGraceTime 2m/g" /etc/ssh/sshd_config
# RUN sed -i "s#PasswordAuthentication yes/PasswordAuthentication yes/g" /etc/ssh/sshd_config
# RUN echo "listen_port=2121" >> /etc/vsftpd.conf

RUN service ssh stop
RUN echo \
	$'Port 22\n\
	AddressFamily any \n\
	ListenAddress 0.0.0.0 \n\
	ChrootDirectory \/home \n\
	AllowGroups ftp_users \n\
	LoginGraceTime 2m \n\
	PasswordAuthentication yes \n\
	X11Forwarding no' >> /etc/ssh/sshd_config.d/my_config

RUN addgroup ftp_users
RUN useradd -m wp-filer -g ftp_users

# RUN usermod -d /home/wp-filer/ wp-filer

RUN echo 'wp-filer:sercer_pass' | chpasswd


RUN chmod 700 /home/wp-filer

RUN service ssh start

# ENTRYPOINT [ "vsftpd", "/etc/vsftpd.conf" ]
ENTRYPOINT [ "bash" ]
