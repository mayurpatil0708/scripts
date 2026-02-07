#!/bin/bash
set -e

if [ "$EUID" -ne 0 ]; then
  echo "Error: Please run as root (use sudo -i)"
  exit 1
fi

echo "==> Adding Jenkins repository"
curl -fsSL https://pkg.jenkins.io/redhat-stable/jenkins.repo \
  -o /etc/yum.repos.d/jenkins.repo

echo "==> Importing Jenkins GPG key"
rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key

echo "==> Refreshing package metadata"
dnf clean all
dnf makecache

echo "==> Installing Java 17 and Jenkins"
dnf install -y java-17-openjdk jenkins

echo "==> Enabling and starting Jenkins"
systemctl daemon-reload
systemctl enable --now jenkins

if command -v firewall-cmd >/dev/null 2>&1 && systemctl is-active --quiet firewalld; then
  echo "==> Opening port 8080"
  firewall-cmd --permanent --add-port=8080/tcp
  firewall-cmd --reload
fi

echo "-------------------------------------------------------"
echo "Jenkins is running"
echo "Access via: http://<PUBLIC-IP>:8080"
echo "Initial Admin Password:"
cat /var/lib/jenkins/secrets/initialAdminPassword
echo "-------------------------------------------------------"
