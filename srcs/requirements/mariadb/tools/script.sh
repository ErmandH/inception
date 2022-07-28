#!/bin/sh -e

if [ ! -d "/var/lib/mysql/mysql" ]; then
	echo "Creating data folder"

	mysql_install_db --datadir=/var/lib/mysql --user=mysql
else
	chown -R mysql:mysql /var/lib/mysql
fi

if [ ! -d "/var/lib/mysql/${MYSQL_NAME}" ]; then
	echo "Creating database --${MYSQL_NAME}--"
	rc-service mariadb start

	mysql -u root -e "DROP DATABASE IF EXISTS test;"
	mysql -u root -e "DELETE FROM mysql.user WHERE User=''";
	mysql -u root -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_NAME};"
	mysql -u root -e "CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -u root -e "GRANT ALL PRIVILEGES ON ${MYSQL_NAME}.* TO '${MYSQL_USER}'@'%';"
	mysql -u root -e "FLUSH PRIVILEGES;"
	mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

	rc-service mariadb stop
fi

mysqld_safe -u mysql --datadir=/var/lib/mysql