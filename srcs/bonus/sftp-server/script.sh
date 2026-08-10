#!/bin/bash
set -e

if ! id -u "${FTP_USER}" &>/dev/null; then
    useradd -m -s /bin/bash -d /var/www/wordpress "${FTP_USER}"
    echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
fi

chown -R "${FTP_USER}":"${FTP_USER}" /var/www/wordpress

ssh-keygen -A

cat << EOF > /etc/ssh/sshd_config
Port 22
PermitRootLogin no
PasswordAuthentication yes
Subsystem sftp internal-sftp

Match User ${FTP_USER}
    ForceCommand internal-sftp
    AllowTcpForwarding no
    X11Forwarding no
EOF

exec /usr/sbin/sshd -D
