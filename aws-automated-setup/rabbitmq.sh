#!/bin/bash

cat > /etc/yum.repos.d/rabbitmq.repo <<EOF
[fedora-epel]
name=fedora-epel
baseurl=https://dl.fedoraproject.org/pub/fedora/linux/releases/39/Everything/x86_64/os/
enabled=1
gpgcheck=0
EOF

yum -y install rabbitmq-server
rpm -qi rabbitmq-server
systemctl start rabbitmq-server
systemctl enable rabbitmq-server
sh -c 'echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config'
rabbitmqctl add_user test test
rabbitmqctl set_user_tags test administrator
systemctl restart rabbitmq-server

# yum install firewalld -y
# systemctl start firewalld
# systemctl enable firewalld
# firewall-cmd --add-port=5672/tcp
# firewall-cmd --runtime-to-permanent
