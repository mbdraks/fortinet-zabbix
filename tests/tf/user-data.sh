#!/bin/bash

echo "=== User Data start ==="

# https://www.zabbix.com/documentation/5.0/manual/installation/install_from_packages/debian_ubuntu

###########################################################
# VARIABLES -- CHANGE THINGS HERE
###########################################################
# ZABBIX_PKG_NAME="zabbix-release_5.0-1+bionic_all.deb"
# ZABBIX_REPO_URL="https://repo.zabbix.com/zabbix/5.0/ubuntu/pool/main/z/zabbix-release"
ZABBIX_PKG_NAME="zabbix-release_5.2-1+ubuntu18.04_all.deb"
ZABBIX_REPO_URL="https://repo.zabbix.com/zabbix/5.2/ubuntu/pool/main/z/zabbix-release"


DB_HOST="localhost"
DB_PORT=3306
DB_USER="zabbix" # change your zabbix database username as needed
DB_PASS="zabbix" # change your zabbix database password as needed
DB_NAME="zabbix" # change your zabbix database name as needed
ZBX_SERVER_HOST="localhost"

DB_SERVER_HOST=${DB_HOST}
DB_SERVER_PORT=${DB_PORT}
DB_SERVER_DBNAME=${DB_NAME}
MYSQL_USER=${DB_USER}
MYSQL_PASSWORD=${DB_PASS}
MYSQL_DATABASE=${DB_NAME}

ZBX_LOADMODULE=""
ZBX_DEBUGLEVEL=5
ZBX_TIMEOUT=10

# ***** THERE IS NO NEED TO CHANGE ANYTHING AFTER THIS POINT **** #

###########################################################
# COMMON
###########################################################
AWS_INSTANCE_ID=`curl -s http://169.254.169.254/latest/meta-data/instance-id`
TEMP_INSTALL_DIR="/root/install"

mkdir ${TEMP_INSTALL_DIR}
cd ${TEMP_INSTALL_DIR}
wget ${ZABBIX_REPO_URL}/${ZABBIX_PKG_NAME}
dpkg -i ${ZABBIX_PKG_NAME}

# update OS
mv /boot/grub/menu.lst /tmp/
update-grub-legacy-ec2 -y
apt-get dist-upgrade -qq --force-yes
apt update
apt full-upgrade -y

###########################################################
# MySQL INSTALLATION AND CONFIGURATION FOR ZABBIX
###########################################################

apt install zabbix-server-mysql -y
cp -pd /etc/zabbix/zabbix_server.conf /etc/zabbix/zabbix_server.conf.orig

service zabbix-server start
update-rc.d zabbix-server enable

###########################################################
# ZABBIX FRONTEND
###########################################################

apt install apache2 -y
apt install php libapache2-mod-php -y
update-rc.d apache2 enable
service apache2 start

apt install zabbix-frontend-php -y
service apache2 restart

###########################################################
# ZABBIX DATA
###########################################################

cd ${TEMP_INSTALL_DIR}

apt install mysql-server -y
service mysql start
update-rc.d mysql enable

echo "CREATE DATABASE IF NOT EXISTS ${DB_NAME} CHARACTER SET utf8 COLLATE utf8_bin;" > ${TEMP_INSTALL_DIR}/create_zabbix.sql
echo "GRANT ALL ON *.* TO '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';" >> ${TEMP_INSTALL_DIR}/create_zabbix.sql
echo "FLUSH PRIVILEGES;" >> ${TEMP_INSTALL_DIR}/create_zabbix.sql
mysql -u root < ${TEMP_INSTALL_DIR}/create_zabbix.sql

zcat /usr/share/doc/zabbix-server-mysql/create.sql.gz | mysql -u root ${DB_NAME}

###########################################################
# ZABBIX AGENT
###########################################################

apt install zabbix-agent -y
service zabbix-agent start

###########################################################
# ZABBIX CONFIG
###########################################################

cat > /etc/apache2/conf-available/zabbix.conf <<EOF
#
# Zabbix monitoring system php web frontend
#

Alias /zabbix /usr/share/zabbix

<Directory "/usr/share/zabbix">
    Options FollowSymLinks
    AllowOverride None
    Require all granted

    <IfModule mod_php7.c>
        php_value max_execution_time 300
        php_value memory_limit 512M
        php_value post_max_size 128M
        php_value upload_max_filesize 128M
        php_value max_input_time 300
        php_value max_input_vars 10000
        php_value always_populate_raw_post_data -1
        php_value date.timezone America/Toronto
    </IfModule>
</Directory>

<Directory "/usr/share/zabbix/conf">
    Require all denied
</Directory>

<Directory "/usr/share/zabbix/app">
    Require all denied
</Directory>

<Directory "/usr/share/zabbix/include">
    Require all denied
</Directory>

<Directory "/usr/share/zabbix/local">
    Require all denied
</Directory>
EOF
ln -s /etc/apache2/conf-available/zabbix.conf /etc/apache2/conf-enabled/zabbix.conf

###########################################################
# ZABBIX GUI CONFIG
###########################################################

cat > /usr/share/zabbix/conf/zabbix.conf.php <<EOF
<?php
// Zabbix GUI configuration file.

\$DB['TYPE']                 = 'MYSQL';
\$DB['SERVER']               = 'localhost';
\$DB['PORT']                 = '0';
\$DB['DATABASE']             = 'zabbix';
\$DB['USER']                 = 'zabbix';
\$DB['PASSWORD']             = 'zabbix';

// Schema name. Used for PostgreSQL.
\$DB['SCHEMA']               = '';

// Used for TLS connection.
\$DB['ENCRYPTION']           = false;
\$DB['KEY_FILE']             = '';
\$DB['CERT_FILE']            = '';
\$DB['CA_FILE']              = '';
\$DB['VERIFY_HOST']          = false;
\$DB['CIPHER_LIST']          = '';

// Vault configuration. Used if database credentials are stored in Vault secrets manager.
\$DB['VAULT_URL']            = '';
\$DB['VAULT_DB_PATH']        = '';
\$DB['VAULT_TOKEN']          = '';

\$DB['DOUBLE_IEEE754']       = true;

\$ZBX_SERVER                 = 'localhost';
\$ZBX_SERVER_PORT            = '10051';
\$ZBX_SERVER_NAME            = 'zabbix';

\$IMAGE_FORMAT_DEFAULT       = IMAGE_FORMAT_PNG;
?>
EOF


###########################################################
# ZABBIX SERVER CONFIG
###########################################################
mkdir -p /run/zabbix/
cat > /etc/zabbix/zabbix_server.conf <<EOF
LogFile=/var/log/zabbix/zabbix_server.log
LogFileSize=0
PidFile=/run/zabbix/zabbix_server.pid
SocketDir=/var/run/zabbix
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
Timeout=4
FpingLocation=/usr/bin/fping
LogSlowQueries=3000
StatsAllowedIP=127.0.0.1
EOF

###########################################################
# RESTART ZABBIX AND APACHE
###########################################################

service zabbix-server restart
service apache2 restart
service zabbix-agent restart

echo "=== User Data end ==="
