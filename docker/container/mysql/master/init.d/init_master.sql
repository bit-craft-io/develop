CREATE USER 'guest'@'%' IDENTIFIED WITH mysql_native_password BY 'guest';
GRANT ALL PRIVILEGES ON *.* TO 'guest'@'%' WITH GRANT OPTION;
FLUSH PRIVILEGES;

CREATE USER 'replica'@'%' IDENTIFIED WITH mysql_native_password BY 'replica';
GRANT REPLICATION SLAVE ON *.* TO 'replica'@'%';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS pest;
GRANT ALL PRIVILEGES ON pest.* TO 'root'@'%';
