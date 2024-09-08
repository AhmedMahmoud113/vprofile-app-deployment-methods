#!/bin/bash

# Switch to root user
sudo -i

# Update package list and install Nginx
apt update
apt install nginx -y

# Create Nginx configuration file for the vproapp application
cat <<EOT > vproapp
upstream vproapp {
  server app01:8080; # Define upstream server for vproapp, with app01 handling traffic on port 8080
}

server {
  listen 80; # Listen on port 80 for incoming HTTP requests

  location / {
    proxy_pass http://vproapp; # Forward all requests to the upstream server defined above
  }
}

EOT

# Move the new configuration file to Nginx's sites-available directory
mv vproapp /etc/nginx/sites-available/vproapp

# Remove the default Nginx configuration to avoid conflicts
rm -rf /etc/nginx/sites-enabled/default

# Create a symbolic link to enable the vproapp configuration
ln -s /etc/nginx/sites-available/vproapp /etc/nginx/sites-enabled/vproapp

# Start and enable Nginx service to run at boot, then restart to apply changes
systemctl start nginx
systemctl enable nginx
systemctl restart nginx
