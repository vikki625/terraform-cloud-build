#!/bin/bash

# Update the system
sudo apt-get update && sudo apt-get upgrade -y

# Install Google Cloud SDK
echo "Installing Google Cloud SDK..."
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init

# Check if npm is installed, if not, install it
if ! command -v npm &> /dev/null
then
    echo "npm could not be found, installing now..."
    sudo apt-get install -y npm
fi

# Install Firebase CLI
echo "Installing Firebase CLI..."
sudo npm install -g firebase-tools

# Install Terraform
echo "Installing Terraform..."
TERRAFORM_VERSION="1.0.9" # Specify the version of Terraform you want to install
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "All installations completed successfully!"
