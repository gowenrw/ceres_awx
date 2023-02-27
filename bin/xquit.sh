#!/bin/bash
# If we are in the bin dir back up to project root
PWDDIR=$(pwd)
if [ "${PWDDIR:(-4)}" == "/bin" ]; then
  cd ..
fi
# Get system name
UNAMEN=$(uname -n)
vagrant halt
vagrant status
echo "tar -cvf .vagrantbackup-$UNAMEN.tar .vagrant"
tar -cvf .vagrantbackup-$UNAMEN.tar .vagrant
