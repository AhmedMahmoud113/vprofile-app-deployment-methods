# vProfile Project - Manual Vagrant Setup

## Introduction:
This section outlines the manual deployment of the VProfile application using Vagrant. The purpose of this approach is to demonstrate a hands-on method where each service and configuration is manually set up, providing deeper insight into the underlying infrastructure.

## Prerequisites:
Before proceeding with the manual setup, ensure you have the following installed on your system:

- Oracle VM VirtualBox
- Vagrant
- Vagrant plugins (e.g., vagrant-hostmanager)  
  Execute the following command on your computer to install the hostmanager plugin:

  ```ruby
  vagrant plugin install vagrant-hostmanager
  ```

- Git Bash or an equivalent editor

## Project Overview:
The VProfile application is a multi-tiered web application with various services, including:

- **Nginx**: Web server
- **Tomcat**: Application server
- **RabbitMQ**: Message broker
- **Memcached**: Database caching
- **ElasticSearch**: Indexing and search service
- **MySQL**: SQL database

## Installation

### 1. MySQL Setup

1. Login to the `db01` VM:
    ```ruby
    vagrant ssh db01
    ```

2. Verify hosts entry and update if missing:
    ```ruby
    cat /etc/hosts
    ```

3. Update OS with the latest patches:
    ```ruby
    yum update -y
    ```

4. Set the repository and install MariaDB:
    ```ruby
    yum install epel-release -y
    yum install git mariadb-server -y
    ```

5. Start and enable MariaDB:
    ```ruby
    systemctl start mariadb
    systemctl enable mariadb
    ```

6. Run MySQL secure installation script:
    ```ruby
    mysql_secure_installation
    ```

    > **Note**: Set the root password, using `admin123` as an example.

![MySQL Setup](https://github.com/user-attachments/assets/31e79e7e-716d-42aa-a9d7-5be04d8f01f7)

7. Create the database and set up users:
    ```ruby
    mysql -u root -padmin123
    ```

    Inside the MySQL prompt:
    ```ruby
    CREATE DATABASE accounts;
    GRANT ALL PRIVILEGES ON accounts.* TO 'admin'@'%' IDENTIFIED BY 'admin123';
    FLUSH PRIVILEGES;
    exit;
    ```

8. Download the source code and initialize the database:
    ```ruby
    git clone -b main https://github.com/AhmedMahmoud113/vprofile-app-deployment-methods.git
    cd vprofile-app-deployment-methods
    mysql -u root -padmin123 accounts < src/main/resources/db_backup.sql
    mysql -u root -padmin123 accounts
    ```

9. Verify the database setup:
    ```ruby
    SHOW TABLES;
    exit;
    ```

10. Restart MariaDB:
    ```ruby
    systemctl restart mariadb
    ```

11. Configure firewall to allow MariaDB access on port 3306:
    ```ruby
    systemctl start firewalld
    systemctl enable firewalld
    firewall-cmd --get-active-zones
    firewall-cmd --zone=public --add-port=3306/tcp --permanent
    firewall-cmd --reload
    systemctl restart mariadb
    ```

---

### 2. Memcached Setup

1. Login to the `mc01` VM:
    ```ruby
    vagrant ssh mc01
    ```

2. Verify hosts entry and update if necessary:
    ```ruby
    cat /etc/hosts
    ```

3. Update OS with the latest patches:
    ```ruby
    yum update -y
    ```

4. Install, start, and enable Memcached on port 11211:
    ```ruby
    sudo dnf install epel-release -y
    sudo dnf install memcached -y
    sudo systemctl start memcached
    sudo systemctl enable memcached
    sudo systemctl status memcached
    sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached
    sudo systemctl restart memcached
    ```

5. Configure firewall to allow access to Memcached:
    ```ruby
    firewall-cmd --add-port=11211/tcp
    firewall-cmd --runtime-to-permanent
    firewall-cmd --add-port=11111/udp
    firewall-cmd --runtime-to-permanent
    sudo memcached -p 11211 -U 11111 -u memcached -d
    ```

---

### 3. RabbitMQ Setup

1. Login to the `rmq01` VM:
    ```ruby
    vagrant ssh rmq01
    ```

2. Verify hosts entry and update if necessary:
    ```ruby
    cat /etc/hosts
    ```

3. Update OS with the latest patches:
    ```ruby
    yum update -y
    ```

4. Install RabbitMQ:
    ```ruby
    yum install epel-release -y
    sudo yum install wget -y
    dnf -y install centos-release-rabbitmq-38
    dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server
    systemctl enable --now rabbitmq-server
    ```

5. Setup RabbitMQ user:
    ```ruby
    sudo rabbitmqctl add_user test test
    sudo rabbitmqctl set_user_tags test administrator
    ```

6. Configure firewall for RabbitMQ:
    ```ruby
    firewall-cmd --add-port=5672/tcp
    firewall-cmd --runtime-to-permanent
    sudo systemctl restart rabbitmq-server
    ```

---

### 4. Tomcat Setup

1. Login to the `app01` VM:
    ```ruby
    vagrant ssh app01
    ```

2. Verify hosts entry and update if necessary:
    ```ruby
    cat /etc/hosts
    ```

3. Install Java and other dependencies:
    ```ruby
    dnf -y install java-11-openjdk java-11-openjdk-devel git maven wget
    ```

4. Download and extract Tomcat:
    ```ruby
    cd /tmp/
    wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz
    tar xzvf apache-tomcat-9.0.75.tar.gz
    ```

5. Create a Tomcat user and set permissions:
    ```ruby
    useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat
    cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/
    chown -R tomcat.tomcat /usr/local/tomcat
    ```

6. Create and configure Tomcat service:
    ```ruby
    vi /etc/systemd/system/tomcat.service
    ```

    Add the following content to the file:
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
    ExecStart=/usr/local/tomcat/bin/catalina.sh run
    ExecStop=/usr/local/tomcat/bin/shutdown.sh
    SyslogIdentifier=tomcat-%i

    [Install]
    WantedBy=multi-user.target
    ```

7. Reload systemd, start, and enable Tomcat:
    ```ruby
    systemctl daemon-reload
    systemctl start tomcat
    systemctl enable tomcat
    ```

8. Configure firewall for Tomcat:
    ```ruby
    systemctl start firewalld
    systemctl enable firewalld
    firewall-cmd --zone=public --add-port=8080/tcp --permanent
    firewall-cmd --reload
    ```

---

### 5. Nginx Setup

1. Login to the `web01` VM:
    ```ruby
    vagrant ssh web01
    sudo -i
    ```

2. Update OS with the latest patches:
    ```ruby
    apt update && apt upgrade -y
    ```

3. Install Nginx:
    ```ruby
    apt install nginx -y
    ```

4. Configure Nginx to proxy requests to Tomcat:
    ```ruby
    vi /etc/nginx/sites-available/vproapp
    ```

    Add the following content:
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

5. Activate the configuration:
    ```ruby
    ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/
    rm -rf /etc/nginx/sites-enabled/default
    systemctl restart nginx
    ```

---

## Challenges and Solutions:
During the manual setup, various challenges may arise, such as VM setup issues or service configuration errors. However, these challenges provide valuable learning opportunities and help develop problem-solving skills.
