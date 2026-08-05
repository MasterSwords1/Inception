#!/bin/bash
set -e

# Create SFTP user if it doesn't exist
if ! id -u "${FTP_USER}" &>/dev/null; then
    useradd -m -s /bin/bash -d /var/www/wordpress "${FTP_USER}"
    echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
fi

# Set permissions
chown -R "${FTP_USER}":"${FTP_USER}" /var/www/wordpress

# Generate host keys if they don't exist
ssh-keygen -A

# Configure SSH for SFTP
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
