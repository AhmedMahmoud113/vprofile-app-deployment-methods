#!/bin/bash

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
