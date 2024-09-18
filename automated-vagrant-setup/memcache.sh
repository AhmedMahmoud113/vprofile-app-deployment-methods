#!/bin/bash

# Update the system and install required packages
sudo yum update -y
sudo dnf install epel-release -y
sudo dnf install memcached -y

# Start and enable Memcached service
sudo systemctl start memcached
sudo systemctl enable memcached

# Check the status of the Memcached service
sudo systemctl status memcached

# Modify Memcached configuration to listen on all IP addresses
sudo sed -i 's/127.0.0.1/0.0.0.0/g' /etc/sysconfig/memcached

# Restart Memcached service to apply changes
sudo systemctl restart memcached

# Enable and start the firewalld service
sudo systemctl enable --now firewalld

# Open port 11211 for Memcached TCP traffic
sudo firewall-cmd --add-port=11211/tcp

# Make the firewall rule permanent
sudo firewall-cmd --runtime-to-permanent

# Open port 11111 for Memcached UDP traffic
sudo firewall-cmd --add-port=11111/udp

# Make the firewall rule permanent
sudo firewall-cmd --runtime-to-permanent

# Start Memcached with specified ports and as a daemon
sudo memcached -p 11211 -U 11111 -u memcached -d
