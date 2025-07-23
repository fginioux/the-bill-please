#!/bin/bash

# Get EC2 IPs
BASTION_IP=$(terraform -chdir=terraform output -raw bastion_public_ip)
API_IP=$(terraform -chdir=terraform output -raw api_server_public_ip)

# Path to SSH key
KEY_PATH="~/.ssh/aws-ec2"

# Generate ~/.ssh/config
cat <<EOF > ~/.ssh/config
Host bastion
  HostName ${BASTION_IP}
  User ubuntu
  Port 22
  IdentityFile ${KEY_PATH}
  IdentitiesOnly yes

Host api-server
  HostName ${API_IP}
  User ubuntu
  IdentityFile ${KEY_PATH}
  IdentitiesOnly yes
  ProxyJump bastion
EOF

echo "file ~/.ssh/config generated"
