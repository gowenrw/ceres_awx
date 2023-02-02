#!/bin/bash

# Vagrant VMs with Keys
vMList=(
  "ceres-a"
  "ceres-b"
  "ceres-c"
  "ceres-ctrl"
  "ceres-rectal"
)

# Loop Through Keys
for keyvm in ${vMList[@]}; do
  keyfile=".vagrant/machines/$keyvm/virtualbox/private_key"
  if test -f "$keyfile"; then
    echo "copy $keyfile -> ssh.$keyvm.private_key"
    cp $keyfile ssh.$keyvm.private_key
  fi
done
