#!/bin/bash

# Exit immediately if a command fails

set -e

echo "Removing Podman (if present)..."
sudo dnf remove -y podman podman-docker buildah || true
sudo rm -rf /var/lib/containers || true

echo "Installing required utilities..."
sudo dnf install -y yum-utils

echo "Adding Docker repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "Installing Docker..."
sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

echo "Starting and enabling Docker..."
sudo systemctl enable --now docker

echo "Adding current user to docker group..."
sudo usermod -aG docker $USER

echo "Verifying Docker installation..."
sudo docker run hello-world

echo "Docker installation complete!"
echo "IMPORTANT: Logout and login again to use Docker without sudo."
