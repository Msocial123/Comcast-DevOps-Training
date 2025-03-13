#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Update package list
echo ">>> Updating package list..."
sudo apt-get update -y

# Define variables
KUBECTL_VERSION="1.30.4"
KUBECTL_DATE="2024-09-11"
AWS_CLI_URL="https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip"
EKSCTL_URL="https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz"

echo ">>> Installing kubectl..."
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_DATE}/bin/linux/amd64/kubectl
curl -O https://s3.us-west-2.amazonaws.com/amazon-eks/${KUBECTL_VERSION}/${KUBECTL_DATE}/bin/linux/amd64/kubectl.sha256
sha256sum -c kubectl.sha256

chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl
echo 'export PATH=$HOME/bin:$PATH' >> ~/.bashrc
export PATH=$HOME/bin:$PATH

echo ">>> Verifying kubectl installation..."
kubectl version --client

echo ">>> Installing AWS CLI..."
curl "$AWS_CLI_URL" -o "awscliv2.zip"
sudo apt-get install unzip -y  # Install unzip if not present
unzip awscliv2.zip
sudo ./aws/install

echo ">>> Installing eksctl..."
curl --silent --location "$EKSCTL_URL" | tar xz -C /tmp
sudo mv /tmp/eksctl /usr/local/bin

echo ">>> Verifying eksctl installation..."
eksctl version

echo ">>> Installation Complete!"
