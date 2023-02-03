#!/bin/bash
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
