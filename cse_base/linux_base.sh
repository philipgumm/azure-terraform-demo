#!/bin/bash

# Enable EPEL repository (Ansible dependencies)
sudo dnf install -y epel-release

# Update system
sudo dnf update -y

# Install Ansible
sudo dnf install -y ansible

# Verify installation
ansible --version

# Enable SSH for Ansible
sudo systemctl enable sshd
sudo systemctl start sshd

# Allow password authentication (optional)
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config
sudo systemctl restart sshd

# Create an Ansible user (optional)
sudo useradd -m -s /bin/bash ansible
echo "ansible:password" | sudo chpasswd
echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible

# Log installation status
echo "Ansible installation complete." > /tmp/ansible_install.log
