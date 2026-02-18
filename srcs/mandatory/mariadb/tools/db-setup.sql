CREATE DATABASE IF NOT EXISTS wordpress_db;
USE wordpress_db;
CREATE USER moulchi@localhost IDENTIFIED BY 'moulchi-inc';
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'moulchi'@localhost;
FLUSH PRIVILEGES;
