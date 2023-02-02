#!/bin/bash

# Vagrant Keys
vKeyList=(
  ".vagrant/machines/ceres-a/virtualbox/private_key"
  ".vagrant/machines/ceres-b/virtualbox/private_key"
  ".vagrant/machines/ceres-c/virtualbox/private_key"
  ".vagrant/machines/ceres-datass/virtualbox/private_key"
  ".vagrant/machines/ceres-rectal/virtualbox/private_key"
)

# Loop Through Keys
for keyfile in ${vKeyList[@]}; do
  #echo $keyfile
  if test -f "$keyfile"; then
    vmname=`echo $keyfile | sed -e 's/\.vagrant\/machines\///; s/\/virtualbox\/private_key//'`
    echo "copy $keyfile -> ssh.$vmname.private_key"
    cp $keyfile ssh.$vmname.private_key
  fi
done

