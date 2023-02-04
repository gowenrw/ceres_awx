#!/bin/bash

# DOES NOT WORK IN NATIVE WINDOWS OR WIN-GIT-BASH CLI
echo "------------------------------------------"
echo "REQUIRES LINUX PUTTYGEN IN WSL OR LINUX VM"
echo "------------------------------------------"

# Run from shared directory if running from local ansible control vm
runpwd=`pwd`
if test -f "/vagrant"; then
  runfrom="/vagrant"
else
  runfrom="$pwd"
fi

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
  vkeyfile="$runfrom/.vagrant/machines/$keyvm/virtualbox/private_key"
  keyfile="$runfrom/ssh.$keyvm.private_key"
  keyppk="$runfrom/ssh.$keyvm.ppk"
  if test -f "$vkeyfile"; then
    echo "copy $vkeyfile -> $keyfile"
    cp $vkeyfile $keyfile
    echo "puttygen convert $keyfile -> $keyppk"
    puttygen $keyfile -o $keyppk
  fi
done

# Copy ssh keys from shared directory if running from local ansible control vm
if test -f "/vagrant"; then
  cp $keyfile $pwd
fi
