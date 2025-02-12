#!/bin/bash

# Log start time
echo "Starting script execution..." > /tmp/custom_script.log
date >> /tmp/custom_script.log

# Ensure system has internet access before proceeding
if ! curl -s --head http://www.google.com | grep "200 OK" > /dev/null; then
  echo "ERROR: No internet access. Exiting." | tee -a /tmp/custom_script.log
  exit 1
fi

# Install dependencies with a timeout to prevent Terraform failures
timeout 600 sudo dnf install -y epel-release >> /tmp/custom_script.log 2>&1
timeout 1200 sudo dnf update -y >> /tmp/custom_script.log 2>&1
timeout 600 sudo dnf install -y ansible >> /tmp/custom_script.log 2>&1

# Verify Ansible installation
ansible --version >> /tmp/custom_script.log 2>&1 
if [ $? -ne 0 ]; then
  echo "ERROR: Ansible installation failed." | tee -a /tmp/custom_script.log
  exit 1
fi

# Modify SSH authentication settings
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Add ansible user safely
if id "ansible" &>/dev/null; then
  echo "User 'ansible' already exists." | tee -a /tmp/custom_script.log
else
  sudo useradd -m -s /bin/bash ansible
  echo "ansible:password" | sudo chpasswd
  echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible
fi

# Log installation status
echo "Ansible installation complete." > /tmp/ansible_install.log

# Log completion time
echo "Script execution completed." | tee -a /tmp/custom_script.log
date >> /tmp/custom_script.log

# Restart SSH at the very end
# Enable and start SSH
# sudo systemctl enable sshd >> /tmp/custom_script.log 2>&1
# sudo systemctl start sshd >> /tmp/custom_script.log 2>&1
# sleep 5
# sudo systemctl restart sshd