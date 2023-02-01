#!/bin/bash

# Vagrant Keys
vKeyList=(
  ".vagrant/machines/ceres-a/virtualbox/private_key"
  ".vagrant/machines/ceres-b/virtualbox/private_key"
  ".vagrant/machines/ceres-c/virtualbox/private_key"
)

# Loop Through Keys
for keyfile in ${vKeyList[@]}; do
  #echo $keyfile
  if test -f "$keyfile"; then
    vmname=`echo $keyfile | sed -e 's/\.vagrant\/machines\///; s/\/virtualbox\/private_key//'`
    echo "copy $keyfile -> ssh.$vmname.private_key"
    cp $keyfile ssh.$vmname.private_key
    echo "puttygen convert ssh.$vmname.private_key -> ssh.$vmname.ppk"
    puttygen ssh.$vmname.private_key -o ssh.$vmname.ppk
  fi
done

#echo "copy .vagrant/machines/ceres-a/virtualbox/private_key -> ssh.ceres-a.private_key"
#cp .vagrant/machines/ceres-a/virtualbox/private_key ssh.ceres-a.private_key
#echo "copy .vagrant/machines/ceres-b/virtualbox/private_key -> ssh.ceres-b.private_key"
#cp .vagrant/machines/ceres-b/virtualbox/private_key ssh.ceres-b.private_key
#echo "copy .vagrant/machines/ceres-c/virtualbox/private_key -> ssh.ceres-c.private_key"
#cp .vagrant/machines/ceres-c/virtualbox/private_key ssh.ceres-c.private_key

#echo "puttygen convert ssh.ceres-a.private_key -> ssh.ceres-a.ppk"
#puttygen ssh.ceres-a.private_key -o ssh.ceres-a.ppk
#echo "puttygen convert ssh.ceres-b.private_key -> ssh.ceres-b.ppk"
#puttygen ssh.ceres-b.private_key -o ssh.ceres-b.ppk
#echo "puttygen convert ssh.ceres-c.private_key -> ssh.ceres-c.ppk"
#puttygen ssh.ceres-c.private_key -o ssh.ceres-c.ppk
