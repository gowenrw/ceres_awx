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

# Loop Through Keys
for keyvm in ${vMList[@]}; do
  keyfile="ssh.$keyvm.private_key"
  if test -f "$keyfile"; then
    echo "puttygen convert $keyfile -> ssh.$keyvm.ppk"
    puttygen $keyfile -o ssh.$keyvm.ppk
  fi
done

