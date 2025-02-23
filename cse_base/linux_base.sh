#!/bin/bash

# Log start time
echo "Starting script execution..." > /tmp/custom_script.log
date >> /tmp/custom_script.log


if ! curl -s --head http://www.google.com | grep "200 OK" > /dev/null; then
  echo "ERROR: No internet access. Exiting." | tee -a /tmp/custom_internet_connectivity.log
  exit 1
fi

timeout 1200 sudo dnf update -y >> /tmp/custom_fedora_update.log 2>&1
timeout 600 sudo dnf install -y epel-release >> /tmp/epel_release.log 2>&1
timeout 200 sudo dnf install -y ansible >> /tmp/custom_ansible_install.log 2>&1

# &> /tmp/custom_script.log


ansible --version >> /tmp/custom_script.log 2>&1 
if [ $? -ne 0 ]; then
  echo "ERROR: Ansible installation failed." | tee -a /tmp/custom_script.log
  exit 1
fi

sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

if id "ansible" &>/dev/null; then
  echo "User 'ansible' already exists." | tee -a /tmp/custom_script.log
else
  sudo useradd -m -s /bin/bash ansible
  echo "ansible:password" | sudo chpasswd
  echo "ansible ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/ansible
fi

echo "Ansible installation complete." > /tmp/ansible_install.log

echo "Script execution completed." | tee -a /tmp/custom_script.log
date >> /tmp/custom_script.log

exit 0
# Maybe we should restart SSH at the very end
# sudo systemctl enable sshd >> /tmp/custom_script.log 2>&1
# sudo systemctl start sshd >> /tmp/custom_script.log 2>&1
# sleep 5
# sudo systemctl restart sshd