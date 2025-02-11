#!/bin/bash
sudo dnf install -y epel-release

sudo dnf update -y
sudo dnf install -y ansible

ansible --version

sudo systemctl enable sshd
sudo systemctl start sshd

sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config


sudo useradd -m -s /bin/bash ansible
echo "ansible:password" | sudo chpasswd
echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible

# Log installation status
echo "Ansible installation complete." > /tmp/ansible_install.log

# Set to restart sudo systemctl restart sshd later
