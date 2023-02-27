#!/bin/bash

# DOES NOT WORK IN NATIVE WINDOWS OR WIN-GIT-BASH CLI
echo "------------------------------------------"
echo "REQUIRES LINUX PUTTYGEN IN WSL OR LINUX VM"
echo "------------------------------------------"

# If we are in the bin dir back up to project root
PWDDIR=$(pwd)
if [ "${PWDDIR:(-4)}" == "/bin" ]; then
  cd ..
fi

# Run from shared dir if on local ansible control vm
runpwd=`pwd`
if test -d "/vagrant"; then
  runfrom="/vagrant"
else
  runfrom="$runpwd"
fi

# Vagrant VMs with Keys
vMList=(
  "ceres-a"
  "ceres-b"
  "ceres-c9"
  "ceres-r9"
  "ceres-ctrl"
  "ceres-rectal"
  "ceres-tst"
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
    # Copy ssh keys from shared dir if on local ansible control vm
    if test -d "/vagrant"; then
      cp $keyfile $runpwd
    fi
  fi
done

