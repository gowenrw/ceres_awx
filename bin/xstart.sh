#!/bin/bash
# If we are in the bin dir back up to project root
PWDDIR=$(pwd)
if [ "${PWDDIR:(-4)}" == "/bin" ]; then
  cd ..
fi
# Get system name
UNAMEN=$(uname -n)
echo "tar -xvf .vagrantbackup-$UNAMEN.tar .vagrant"
tar -xvf .vagrantbackup-$UNAMEN.tar .vagrant
if [ "$UNAMEN" == "DatA55" ]; then
  echo "vagrant up ceres-ctrl"
  vagrant up ceres-ctrl
elif [ "$UNAMEN" == "R3ctalV0mit" ]; then
  echo "vagrant up ceres-rectal"
  vagrant up ceres-rectal
fi
vagrant status
