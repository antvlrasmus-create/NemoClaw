#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates gnupg lsb-release dos2unix python3-pip

echo "Fixing line endings..."
find scripts -type f -name "*.sh" -exec dos2unix {} +
dos2unix bin/nemoclaw.js

echo "Installing Docker CLI..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce-cli

echo "Installing Node.js..."
curl -fsSL https://deb.nodesource.com/setup_22.x | bash -
apt-get install -y nodejs

echo "Installing OpenShell CLI..."
bash scripts/install-openshell.sh
export PATH="$PATH:$HOME/.local/bin:/usr/local/bin"

echo "Running NemoClaw Onboarding..."
node bin/nemoclaw.js onboard --non-interactive

echo "Done!"