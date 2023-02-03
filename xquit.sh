#!/bin/bash
UNAMEN=$(uname -n)
echo "tar -cvf .vagrantbackup-$UNAMEN.tar .vagrant"
tar -cvf .vagrantbackup-$UNAMEN.tar .vagrant
if [ "$UNAMEN" == "DatA55" ]; then
  echo "vagrant halt ceres-ctrl"
  vagrant halt ceres-ctrl
elif [ "$UNAMEN" == "R3ctalV0mit" ]; then
  echo "vagrant halt ceres-rectal"
  vagrant halt ceres-rectal
fi
vagrant status
