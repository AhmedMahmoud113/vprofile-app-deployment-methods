# Project Title

## Introduction:
This section outlines the manual deployment of the VProfile application using Vagrant. The purpose of this approach is to demonstrate a hands-on method where each service and configuration is manually set up, providing deeper insight into the underlying infrastructure.

## Prerequisites:
Before proceeding with the manual setup, ensure you have the following installed on your system:

- Oracle VM VirtualBox
- Vagrant
- Vagrant plugins (e.g., vagrant-hostmanager)  
  Execute the below command in your computer to install the hostmanager plugin:

  ```ruby
  vagrant plugin install vagrant-hostmanager
- Git Bash or an equivalent editor

## Project Overview:
The VProfile application is a multi-tiered web application with various services, including:

- Nginx: Web service
- Tomcat: Application server
- RabbitMQ: Message broker
- Memcache: Database caching
- ElasticSearch: Indexing and search service
- MySQL: SQL database

## Installation
<h3 align="center">1. MYSQL Setup</h3>

Login to the db vm
```ruby
vagrant ssh db01
```
Verify Hosts entry, if entries missing update the it with IP and hostnames
```ruby
cat /etc/hosts
```
Update OS with latest patches
```ruby
yum update -y
```
Set Repository
```ruby
yum install epel-release -y
```
Install Maria DB Package
```ruby
yum install git mariadb-server -y
```
Starting & enabling mariadb-server
```ruby
systemctl start mariadb
systemctl enable mariadb
```
RUN mysql secure installation script.
```ruby
mysql_secure_installation
```
> **Note**: Set db root password, I will be using admin123 as password.

![mysql](https://github.com/user-attachments/assets/31e79e7e-716d-42aa-a9d7-5be04d8f01f7)

Set DB name and users.
```ruby
mysql -u root -padmin123
```
```ruby
mysql> create database accounts;
mysql> grant all privileges on accounts.* TO 'admin'@'%' identified by 'admin123';
mysql> FLUSH PRIVILEGES;
mysql> exit;
```
Download Source code & Initialize Database
```ruby
git clone -b main https://github.com/AhmedMahmoud113/vprofile-app-deployment-methods.git
cd vprofile-app-deployment-methods
mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
mysql -u root -padmin123 accounts
```
```ruby
mysql> show tables;
mysql> exit;
```
Restart mariadb-server
```ruby
systemctl restart mariadb
```
Starting the firewall and allowing the mariadb to access from port no. 3306
```ruby
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=3306/tcp --permanent
firewall-cmd --reload
systemctl restart mariadb
```

<hr style="border: 1px solid #000;">
<h3 align="center">2.MEMCACHE SETUP</h3>

Login to the Memcache vm
```ruby
vagrant ssh mc01
```
Verify Hosts entry, if entries missing update the it with IP and hostnames
```ruby
cat /etc/hosts
```
Update OS with latest patches
```ruby
yum update -y
```
Install, start & enable memcache on port 11211
```ruby
sudo dnf install epel-release -y
sudo dnf install memcached -y
sudo systemctl start memcached
sudo systemctl enable memcached
sudo systemctl status memcached
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
sudo systemctl restart memcached
```
Starting the firewall and allowing the port 11211 to access memcache
```ruby
firewall-cmd --add-port=11211/tcp
firewall-cmd --runtime-to-permanent
firewall-cmd --add-port=11111/udp
firewall-cmd --runtime-to-permanent
sudo memcached -p 11211 -U 11111 -u memcached -d
```

<hr style="border: 1px solid #000;">
<h3 align="center">3.RABBITMQ SETUP</h3>

Login to the RabbitMQ vm
```ruby
vagrant ssh rmq01
```
Verify Hosts entry, if entries missing update the it with IP and hostnames
```ruby
cat /etc/hosts
```
Update OS with latest patches
```ruby
yum update -y
```
Set EPEL Repository
```ruby
yum install epel-release -y
```
Install Dependencies
```ruby
sudo yum install wget -y
cd /tmp/
dnf -y install centos-release-rabbitmq-38
dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
systemctl enable --now rabbitmq-server
```
Setup access to user test and make it admin
```ruby
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator
sudo systemctl restart rabbitmq-server
```
Starting the firewall and allowing the port 5672 to access rabbitmq
```ruby
firewall-cmd --add-port=5672/tcp
firewall-cmd --runtime-to-permanent
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server
sudo systemctl status rabbitmq-server
```

<hr style="border: 1px solid #000;">
<h3 align="center">4.TOMCAT SETUP</h3>

Login to the tomcat vm
```ruby
vagrant ssh app01
```
Verify Hosts entry, if entries missing update the it with IP and hostnames
```ruby
cat /etc/hosts
```
Update OS with latest patches
```ruby
yum update -y
```
Set Repository
```ruby
yum install epel-release -y
```
Install Dependencies
```ruby
dnf -y install java-11-openjdk java-11-openjdk-devel
dnf install git maven wget -y
```
Change dir to /tmp
```ruby
cd /tmp/
```
Download & Tomcat Package
```ruby
wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
tar xzvf apache-tomcat-9.0.75.tar.gz
```
Add tomcat user
```ruby
useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
```
Copy data to tomcat home dir
```ruby
cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
```
Make tomcat user owner of tomcat home dir
```ruby
chown -R tomcat.tomcat /usr/local/tomcat
```
Create tomcat service file
```ruby
vi /etc/systemd/system/tomcat.service
```

Update the file with below content

```ruby
[Unit]
Description=Tomcat
After=network.target

[Service]
User=tomcat
WorkingDirectory=/usr/local/tomcat
Environment=JRE_HOME=/usr/lib/jvm/jre
Environment=JAVA_HOME=/usr/lib/jvm/jre
Environment=CATALINA_HOME=/usr/local/tomcat
Environment=CATALINE_BASE=/usr/local/tomcat
ExecStart=/usr/local/tomcat/bin/catalina.sh run
ExecStop=/usr/local/tomcat/bin/shutdown.sh
SyslogIdentifier=tomcat-%i

[Install]
WantedBy=multi-user.target
```
Reload systemd files
```ruby
systemctl daemon-reload
```
Start & Enable service
```ruby
systemctl start tomcat
systemctl enable tomcat
```
Enabling the firewall and allowing port 8080 to access the tomcat
```ruby
systemctl start firewalld
systemctl enable firewalld
firewall-cmd --get-active-zones
firewall-cmd --zone=public --add-port=8080/tcp --permanent
firewall-cmd --reload
```

<hr style="border: 1px solid #000;">
<h3 align="center">CODE BUILD & DEPLOY (app01)</h3>

Download Source code
```ruby
git clone -b main https://github.com/AhmedMahmoud113/vprofile-app-deployment-methods.git
```
Update configuration
```ruby
cd vprofile-app-deployment-methods
vim src/main/resources/application.properties
Update file with backend server details
```
# Build code
Run below command inside the repository (vprofile-project)
```ruby
mvn install
```
Deploy artifact
```ruby
systemctl stop tomcat
rm -rf /usr/local/tomcat/webapps/ROOT*
cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war
systemctl start tomcat
chown tomcat.tomcat /usr/local/tomcat/webapps -R
systemctl restart tomcat
```

<hr style="border: 1px solid #000;">
<h3 align="center">5.NGINX SETUP</h3>

Login to the Nginx vm
```ruby
vagrant ssh web01
sudo -i
```
Verify Hosts entry, if entries missing update the it with IP and hostnames
```ruby
cat /etc/hosts
```
Update OS with latest patches
```ruby
apt update
apt upgrade
```
Install nginx
```ruby
apt install nginx -y
```
Create Nginx conf file
```ruby
vi /etc/nginx/sites-available/vproapp
```
Update with below content
```ruby
upstream vproapp {
    server app01:8080;
}

server {
    listen 80;

    location / {
        proxy_pass http://vproapp;
    }
}

```
Remove default nginx conf
```ruby
rm -rf /etc/nginx/sites-enabled/default
```
Create link to activate website
```ruby
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp
```
Restart Nginx
```ruby
systemctl restart nginx
```

## Challenges and Solutions:
During the manual setup, various challenges may arise, such as VM setup issues or service configuration errors. However, these challenges provide valuable learning opportunities and help develop problem-solving skills.
