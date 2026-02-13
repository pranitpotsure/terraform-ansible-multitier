#!/bin/bash
set -euxo pipefail

RDS_ENDPOINT="${rds_endpoint}"
DB_NAME="${db_name}"
DB_USER="${db_user}"
DB_PASSWORD="${db_password}"

yum update -y
yum install -y git ansible java-17-amazon-corretto maven

cd /opt

git clone https://github.com/pranitpotsure/terraform-ansible-multitier.git

cd terraform-ansible-multitier/ansible/app

ansible-playbook app.yml \
  --extra-vars "db_host=${rds_endpoint} db_name=${db_name} db_user=${db_user} db_password=${db_password}"

echo "APP USER-DATA COMPLETED SUCCESSFULLY" >> /var/log/userdata.log
