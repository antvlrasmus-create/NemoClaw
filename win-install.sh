#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates gnupg lsb-release dos2unix python3-pip git

# Fix CRLF
find scripts/ -type f -name "*.sh" -exec dos2unix {} +

# Install Docker CLI
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update && apt-get install -y docker-ce-cli

# Install OpenShell via pip
pip3 install openshell

# Install Node.js
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

# Run onboarding
node bin/nemoclaw.js onboard --non-interactive