#!/bin/bash

# Update the system and install EPEL repository
sudo yum update -y
sudo yum install epel-release -y

# Install Java 11 JDK and development tools, along with Git, Maven, and Wget
sudo dnf -y install java-11-openjdk java-11-openjdk-devel
sudo dnf install git maven wget -y

# Change directory to /tmp for downloading Tomcat
cd /tmp/

# Download Apache Tomcat 9.0.75 from the official archive
sudo wget https://archive.apache.org/dist/tomcat/tomcat-9/v9.0.75/bin/apache-tomcat-9.0.75.tar.gz

# Extract the downloaded Tomcat archive
sudo tar xzvf apache-tomcat-9.0.75.tar.gz

# Create a new user for Tomcat with no login shell and a specified home directory
sudo useradd --home-dir /usr/local/tomcat --shell /sbin/nologin tomcat

# Copy the extracted Tomcat files to the installation directory
sudo cp -r /tmp/apache-tomcat-9.0.75/* /usr/local/tomcat/

# Change ownership of the Tomcat installation directory to the Tomcat user
sudo chown -R tomcat.tomcat /usr/local/tomcat

# Create a systemd service file for managing Tomcat as a service
cat <<EOT >  /etc/systemd/system/tomcat.service
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
EOT

# Reload systemd to apply the new Tomcat service configuration
sudo systemctl daemon-reload

# Start and enable the Tomcat service to start on boot
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Clone the vprofile project from GitHub
sudo git clone -b main https://github.com/hkhcoder/vprofile-project.git

# Change directory to the vprofile project
cd vprofile-project

# Build the project using Maven
sudo mvn install

# Stop the Tomcat service before deploying the new application
sudo systemctl stop tomcat

# Wait for 20 seconds to ensure Tomcat has stopped completely
sleep 20

# Remove the default ROOT application from Tomcat's webapps directory
sudo rm -rf /usr/local/tomcat/webapps/ROOT

# Deploy the new application by copying the WAR file to Tomcat's webapps directory as ROOT.war
sudo cp target/vprofile-v2.war /usr/local/tomcat/webapps/ROOT.war

# Start the Tomcat service to deploy the new application
sudo systemctl start tomcat

# Wait for 20 seconds to ensure the application is deployed correctly
sleep 20

# Change ownership of the Tomcat webapps directory to the Tomcat user
sudo chown tomcat.tomcat /usr/local/tomcat/webapps -R

# Stop and disable the firewalld service
sudo systemctl stop firewalld
sudo systemctl disable firewalld

# Restart the Tomcat service to ensure all changes are applied
sudo systemctl restart tomcat
