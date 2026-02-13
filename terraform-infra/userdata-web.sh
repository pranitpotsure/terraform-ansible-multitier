#!/bin/bash
set -euxo pipefail

yum update -y
yum install -y git ansible nginx nodejs

systemctl enable nginx
systemctl start nginx

cd /opt

git clone https://github.com/pranitpotsure/terraform-ansible-multitier.git

cd terraform-ansible-multitier/ansible/web

ansible-playbook web.yml \
  --extra-vars "internal_alb_dns=${internal_alb_dns}"

echo "WEB USER-DATA COMPLETED SUCCESSFULLY" >> /var/log/userdata.log
