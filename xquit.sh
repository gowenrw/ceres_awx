#!/bin/bash
UNAMEN=$(uname -n)
vagrant halt
vagrant status
echo "tar -cvf .vagrantbackup-$UNAMEN.tar .vagrant"
tar -cvf .vagrantbackup-$UNAMEN.tar .vagrant
