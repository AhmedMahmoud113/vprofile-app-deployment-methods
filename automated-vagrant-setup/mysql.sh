#!/bin/bash

# Set the root password for MariaDB
DB_ROOT_PASSWORD="admin123"

#SSH configuration section (Uncomment to enable SSH settings)
# SSHD_CONFIG="/etc/ssh/sshd_config"

# Check if the script is run as root (Uncomment to enforce root user execution)
# if [[ $EUID -ne 0 ]]; then
#    exit 1
# fi

# Enable PasswordAuthentication in SSH config (Uncomment to modify SSH settings)
# sed -i '/^#PasswordAuthentication/c\PasswordAuthentication yes' "$SSHD_CONFIG"
# sed -i 's/^PasswordAuthentication.*/PasswordAuthentication yes/' "$SSHD_CONFIG"

# Enable PermitRootLogin in SSH config (Uncomment to allow root login via SSH)
# sed -i '/^#PermitRootLogin/c\PermitRootLogin yes' "$SSHD_CONFIG"
# sed -i 's/^PermitRootLogin.*/PermitRootLogin yes/' "$SSHD_CONFIG"

# Restart SSH service to apply changes (Uncomment to restart SSH)
# systemctl restart sshd

##################

# Update the system and install required packages
sudo yum update -y
sudo yum install expect -y
sudo yum install epel-release -y
sudo yum install git mariadb-server -y

# Start and enable MariaDB service
sudo systemctl start mariadb
sudo systemctl enable mariadb

# Switch to root user for secure installation
sudo -i

# Secure MariaDB installation using expect to automate input
expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Enter current password for root (enter for none):\"
send \"\r\"
expect \"Switch to unix_socket authentication\"
send \"n\r\"
expect \"Change the root password?\"
send \"Y\r\"
expect \"New password:\"
send \"$DB_ROOT_PASSWORD\r\"
expect \"Re-enter new password:\"
send \"$DB_ROOT_PASSWORD\r\"
expect \"Remove anonymous users?\"
send \"Y\r\"
expect \"Disallow root login remotely?\"
send \"n\r\"
expect \"Remove test database and access to it?\"
send \"Y\r\"
expect \"Reload privilege tables now?\"
send \"Y\r\"
expect eof
"
# Secure MariaDB installation using Query
# mysqladmin -u root password "$DATABASE_PASS"
# mysql -u root -p"$DATABASE_PASS" -e "UPDATE mysql.user SET Password=PASSWORD('$DATABASE_PASS') WHERE User='root'"
# mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1')"
# mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.user WHERE User=''"
# mysql -u root -p"$DATABASE_PASS" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
# mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"
# mysql -u root -p"$DATABASE_PASS" -e "create database accounts"
# mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'localhost' identified by 'admin123'"
# mysql -u root -p"$DATABASE_PASS" -e "grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123'"
# mysql -u root -p"$DATABASE_PASS" accounts < /tmp/vprofile-project/src/main/resources/db_backup.sql
# mysql -u root -p"$DATABASE_PASS" -e "FLUSH PRIVILEGES"

# Create a database and grant privileges to a user in MariaDB
mysql -u root -p$DB_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS accounts;
GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
FLUSH PRIVILEGES;
EOF

# Clone the vprofile project repository if it doesn't already exist
if [ ! -d "/tmp/vprofile-project" ]; then
    cd /tmp/
    git clone -b main https://github.com/hkhcoder/vprofile-project.git
fi

# Import the database backup into the accounts database
cd /tmp/vprofile-project
mysql -u root -p$DB_ROOT_PASSWORD accounts < src/main/resources/db_backup.sql <<EOF
SHOW TABLES;
EOF

# Restart MariaDB service to ensure changes take effect
sudo systemctl restart mariadb

# Start and enable firewalld service
sudo systemctl start firewalld
sudo systemctl enable firewalld

# Check active firewall zones
sudo firewall-cmd --get-active-zones

# Allow traffic on port 3306 for MariaDB
sudo firewall-cmd --zone=public --add-port=3306/tcp --permanent

# Reload firewall to apply changes
sudo firewall-cmd --reload

# Restart MariaDB service again as a final step
sudo systemctl restart mariadb
