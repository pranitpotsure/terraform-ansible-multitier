#!/bin/bash
set -euxo pipefail

# Update system
yum update -y

# Install required packages
yum install -y git ansible nginx nodejs

# Enable & start nginx early (Ansible will configure it further)
systemctl enable nginx
systemctl start nginx

# Move to /opt
cd /opt

# Clone your INFRA repository (this repo contains ansible/)
git clone https://github.com/YOUR_GITHUB_USERNAME/terraform-ansible-multitier.git

# Go to web ansible playbook
cd terraform-ansible-multitier/ansible/web

# Run Ansible playbook
ansible-playbook web.yml

# Log completion
echo "WEB USER-DATA COMPLETED SUCCESSFULLY" >> /var/log/userdata.log
