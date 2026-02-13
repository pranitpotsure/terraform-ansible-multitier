#!/bin/bash
set -euxo pipefail

# Update system
yum update -y

# Install required packages
yum install -y git ansible java-17-amazon-corretto maven

# Move to /opt
cd /opt

# Clone your INFRA repository (this repo contains ansible/)
git clone https://github.com/YOUR_GITHUB_USERNAME/terraform-ansible-multitier.git

# Go to app ansible playbook
cd terraform-ansible-multitier/ansible/app

# Run Ansible playbook
ansible-playbook app.yml

# Log completion
echo "APP USER-DATA COMPLETED SUCCESSFULLY" >> /var/log/userdata.log
