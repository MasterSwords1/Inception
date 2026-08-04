#!/bin/bash
set -e

if ! id -u "${FTP_USER}" &>/dev/null; then
    useradd -m -s /bin/bash -d /var/www/wordpress "${FTP_USER}"
    echo "${FTP_USER}:${FTP_USER_PASS}" | chpasswd
fi

mkdir -p /var/run/vsftpd/empty

chown -R "${FTP_USER}":"${FTP_USER}" /var/www/wordpress

exec vsftpd /etc/vsftpd.conf
