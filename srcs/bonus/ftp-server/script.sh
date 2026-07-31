#!/bin/bash
set -e

# Create FTP user and configure their password
if ! id -u "${FTP_USER}" &>/dev/null; then
    useradd -m -s /bin/bash -d /var/www/wordpress "${FTP_USER}"
    echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
fi

# Configure vsftpd secure chroot directory
mkdir -p /var/run/vsftpd/empty

# Apply ownership to WordPress root so FTP user can upload/edit files
chown -R "${FTP_USER}":"${FTP_USER}" /var/www/wordpress

exec vsftpd /etc/vsftpd.conf
