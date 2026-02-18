CREATE DATABASE IF NOT EXISTS wordpress_db;
CREATE USER IF NOT EXISTS moulchi@localhost IDENTIFIED BY 'moulchi-inc';
USE wordpress_db;
GRANT ALL PRIVILEGES ON wordpress_db.* TO 'moulchi'@localhost;
CREATE USER IF NOT EXISTS vice@localhost IDENTIFIED BY 'vice-inc';
GRANT SELECT, INSERT, UPDATE, DELETE, CREATE, DROP, ALTER, INDEX ON wordpress_db.* TO 'vice'@localhost;
FLUSH PRIVILEGES;
