#!/bin/bash

# This script will setup a quick and drity ansible environment on a temp vm
# This is useful for running an ansible job for configuring a full ansible control vm

if [ "$EUID" -ne 0 ]
  then echo "This must be run as root."
  exit
fi
dnf config-manager --set-enabled crb
dnf -y install epel-release epel-next-release
dnf -y update
dnf -y install ansible
ansible-galaxy collection install community.general
ansible-galaxy collection install ansible.posix
