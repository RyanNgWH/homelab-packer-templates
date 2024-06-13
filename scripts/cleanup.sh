#!/bin/bash

# Clean apt
DEBIAN_FRONTEND=noninteractive apt-get autoremove --purge
DEBIAN_FRONTEND=noninteractive apt-get clean -y
DEBIAN_FRONTEND=noninteractive apt-get autoclean -y

# Remove SSH keys to ensure all templated VMs do not have the same SSH keys
rm -f /etc/ssh/*key*
rm -f /root/.ssh/authorized_keys

# Clean log files
cat /dev/null > /var/log/wtmp 2>/dev/null

# Set root password to expire and force user to change the password of the VM after the template has been deployed
passwd --expire root
passwd -l root

# Clear User History
history -c
unset HISTFILE