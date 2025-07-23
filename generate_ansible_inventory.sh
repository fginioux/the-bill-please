#!/bin/bash

# GET IPs from Terraform
BASTION_IP=$(terraform -chdir=terraform output -raw bastion_public_ip)
API_IP=$(terraform -chdir=terraform output -raw api_server_public_ip)

# User name and access key PEM
USER="ubuntu"
PEM_PATH="~/.ssh/aws-ec2"

# Generate hosts.ini
cat <<EOF > ./ansible/hosts.ini
[bastion]
bastion ansible_host=${BASTION_IP} ansible_user=${USER} ansible_ssh_private_key_file=${PEM_PATH}

[api_server]
api_server ansible_host=${API_IP} ansible_user=${USER} ansible_ssh_private_key_file=${PEM_PATH} ansible_ssh_common_args='-o ProxyJump=${USER}@${BASTION_IP}'
EOF

echo "hosts.ini generated"
