#!/bin/bash
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y curl ca-certificates dos2unix gnupg lsb-release

find scripts -type f -name "*.sh" -exec dos2unix {} +
dos2unix bin/nemoclaw.js

echo "Installing Docker CLI..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" > /etc/apt/sources.list.d/docker.list
apt-get update && apt-get install -y docker-ce-cli

echo "Installing OpenShell..."
curl -fsSL https://github.com/NVIDIA/OpenShell/releases/latest/download/openshell-x86_64-unknown-linux-musl.tar.gz | tar xzf - -C /usr/local/bin/

echo "Running Onboard..."
node bin/nemoclaw.js onboard --non-interactive