#!/bin/bash

# DOES NOT WORK IN NATIVE WINDOWS OR WIN-GIT-BASH CLI
echo "------------------------------------------"
echo "REQUIRES LINUX PUTTYGEN IN WSL OR LINUX VM"
echo "------------------------------------------"

# Vagrant VMs with Keys
vMList=(
  "ceres-a"
  "ceres-b"
  "ceres-c"
  "ceres-ctrl"
  "ceres-rectal"
)

# Loop Through VM Keys to Convert
for keyvm in ${vMList[@]}; do
  vkeyfile=".vagrant/machines/$keyvm/virtualbox/private_key"
  keyfile="ssh.$keyvm.private_key"
  if test -f "$vkeyfile"; then
    echo "copy $vkeyfile -> $keyfile"
    cp $vkeyfile $keyfile
    echo "puttygen convert $keyfile -> ssh.$keyvm.ppk"
    puttygen $keyfile -o ssh.$keyvm.ppk
  fi
done

