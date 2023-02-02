#!/bin/bash

# note this only works from linux with putty installed, win puttygen is not cli

# Vagrant Keys
vKeyList=(
  "ssh.ceres-a"
  "ssh.ceres-b"
  "ssh.ceres-c"
  "ssh.ceres-datass"
  "ssh.ceres-rectal"
)

# Loop Through Keys
for keyfile in ${vKeyList[@]}; do
  #echo $keyfile
  if test -f "$keyfile.private_key"; then
    echo "puttygen convert $keyfile.private_key -> $keyfile.ppk"
    puttygen $keyfile.private_key -o $keyfile.ppk
  fi
done

