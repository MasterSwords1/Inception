#!/bin/bash

echo $'AddressFamily any \n
ListenAddress 0.0.0.0 \n
ChrootDirectory /home/wp-filer \n
AllowGroups ftp_users \n
LoginGraceTime 2m \n
PasswordAuthentication no \n
X11Forwarding no' >> /etc/ssh/sshd_config.d/my_config.conf

su -c '/usr/sbin/sshd -p 2222 -D -dddd' root
