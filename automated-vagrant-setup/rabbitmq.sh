#!/bin/bash



# Update the system and install required packages
sudo yum update -y
sudo yum install epel-release -y
sudo yum install wget -y

# Change directory to /tmp for temporary files
cd /tmp/

# Install RabbitMQ repository and RabbitMQ Server
sudo dnf -y install centos-release-rabbitmq-38
sudo dnf --enablerepo=centos-rabbitmq-38 -y install rabbitmq-server

# Enable and start RabbitMQ Server
sudo systemctl enable --now rabbitmq-server

# Modify RabbitMQ configuration to allow remote access by removing loopback restrictions
sudo sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'

# Add a new user "test" with password "test" and assign administrator tag
sudo rabbitmqctl add_user test test
sudo rabbitmqctl set_user_tags test administrator

# Enable and start the firewalld service
sudo systemctl enable --now firewalld

# Open port 5672 for RabbitMQ TCP traffic
sudo firewall-cmd --add-port=5672/tcp

# Make the firewall rule permanent
sudo firewall-cmd --runtime-to-permanent

# Start and enable RabbitMQ Server
sudo systemctl start rabbitmq-server
sudo systemctl enable rabbitmq-server

# Check the status of RabbitMQ Server to ensure it's running
sudo systemctl status rabbitmq-server

# Restart RabbitMQ Server to apply any changes
sudo systemctl restart rabbitmq-server
