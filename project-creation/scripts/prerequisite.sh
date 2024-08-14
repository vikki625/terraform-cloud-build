#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install Google Cloud SDK
install_gcloud() {
    echo "Installing Google Cloud SDK..."
    if command_exists gcloud; then
        echo "Google Cloud SDK is already installed."
    else
        curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-$(curl -s https://dl.google.com/dl/cloudsdk/channels/rapid/components-2.json | grep -oP '(?<=version": ")[^"]*').tar.gz
        tar -xzf google-cloud-sdk-*.tar.gz
        ./google-cloud-sdk/install.sh --quiet
        source ~/.bashrc
        if command_exists gcloud; then
            echo "Google Cloud SDK installed successfully."
        else
            echo "Failed to install Google Cloud SDK." >&2
            exit 1
        fi
    fi
}

# Function to install Terraform
install_terraform() {
    echo "Installing Terraform..."
    if command_exists terraform; then
        echo "Terraform is already installed."
    else
        curl -LO https://releases.hashicorp.com/terraform/$(curl -s https://releases.hashicorp.com/terraform/ | grep -oP 'terraform/\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)/terraform_$(curl -s https://releases.hashicorp.com/terraform/ | grep -oP 'terraform/\K[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)_linux_amd64.zip
        unzip terraform_*.zip
        sudo mv terraform /usr/local/bin/
        if command_exists terraform; then
            echo "Terraform installed successfully."
        else
            echo "Failed to install Terraform." >&2
            exit 1
        fi
    fi
}

# Function to install Firebase CLI
install_firebase() {
    echo "Installing Firebase CLI..."
    if command_exists firebase; then
        echo "Firebase CLI is already installed."
    else
        if command_exists npm; then
            npm install -g firebase-tools --silent
        else
            echo "npm is not installed. Installing npm..."
            curl -L https://www.npmjs.com/install.sh | sh
            npm install -g firebase-tools --silent
        fi
        if command_exists firebase; then
            echo "Firebase CLI installed successfully."
        else
            echo "Failed to install Firebase CLI." >&2
            exit 1
        fi
    fi
}

# Main script execution
install_gcloud
install_terraform
install_firebase

echo "All installations completed successfully."
