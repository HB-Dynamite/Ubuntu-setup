#!/usr/bin/env bash

# Stop immediately if a command fails or an undefined variable is used.
set -Eeuo pipefail

# Basic tools needed by many later installation scripts.
PACKAGES=(
    ca-certificates
    curl
    wget
    gnupg
    software-properties-common
    openssh-client
    rsync
    zip
    unzip
    p7zip-full
)

echo "Updating the package list..."
sudo apt-get update

echo "Installing available system updates..."
sudo apt-get upgrade -y

echo "Installing basic system packages..."
sudo apt-get install -y "${PACKAGES[@]}"

echo "Basic system packages installed successfully."