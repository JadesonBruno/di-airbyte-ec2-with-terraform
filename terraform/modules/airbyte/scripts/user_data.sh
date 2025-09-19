#!/bin/bash

# Script to set up Airbyte on an EC2 instance
# This script is executed as remote-exec provisioner in the airbyte module

# Exit on any error
set -euo pipefail

# Log all output for debugging
exec > >(tee /var/log/airbyte_install.log) 2>&1

# Settings passed via Terraform
HOSTNAME="${hostname}"
DEFAULT_USER="${default_user}"

# Logging function
log () {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $${1:-}"
}

log "starting Airbyte installation script"

# Waiting the system to be ready
log "Waiting the system to be ready..."
sleep 30

# 1. Updating the system
log "Updating the system..."
yum update -y

# 2. Installing Docker Engine
log "Installing Docker Engine..."
yum install -y docker

# 3. Adding ec2-user to the docker group
log "Adding ec2-user to the docker group..."
usermod -aG docker ec2-user

# 4. Starting and enabling Docker service
log "Starting and enabling Docker service..."
systemctl start docker
systemctl enable docker

# Waiting a bit to ensure Docker is fully started
sleep 20

# Verifying Docker is running
if ! systemctl is-active --quiet docker; then
    log "ERROR: Docker is not running"
    exit 1
fi

# 5. Downloading and installing abctl
log "Downloading and installing abctl..."
curl -LsfS https://get.airbyte.com | bash -

# Verifying abctl is installed
if ! command -v abctl &> /dev/null; then
    log "ERROR: abctl could not be found"
    exit 1
fi

# 6. Installing Airbyte
log "Installing Airbyte..."
abctl local install --host "$HOSTNAME" --insecure-cookies
log "Airbyte installation completed"
