# Centos stream on vagrant/vbox notes

Manually installing virtualbox additions on CentOS S9
Note make sure to mount the vboxadditions iso as an optical disk (can remove later)
```
dnf -y install gcc kernel-devel kernel-headers make bzip2 perl
export KERN_DIR=/usr/src/kernels/$(uname -r)
mount -r /dev/cdrom /media
cd /media/
./VBoxLinuxAdditions.run
```

Automatically installing virtualbox additions with vagrant plugin
Also disksize plugin to make boxes bigger
Note: this has already been added to the Vagrantfile so nothing to do
```
vagrant plugin install vagrant-vbguest 
vagrant vbguest --status vm-name
vagrant vbguest --do install
vagrant plugin install vagrant-disksize
vagrant plugin list
```

Add to Vagrantfile for plugin
```
# Uncomment to disable update
# node.vbguest.auto_update = false
# Uncomment to force kernel update for centos
node.vbguest.installer_options = { allow_kernel_upgrade: true }
```

Resize the root partition (if vagrant.disksize made the disk larger)
Within the guest use parted for the partition and resize2fs for ext4 filesystem
```
# parted
(parted) print
(parted) print free
(parted) resizepart 1 29.9GiB
Warning: Partition /dev/sda1 is being used. Are you sure you want to continue?
Yes/No? y
(parted) quit
# resize2fs /dev/sda1
resize2fs 1.46.5 (30-Dec-2021)
Filesystem at /dev/sda1 is mounted on /; on-line resizing required
old_desc_blocks = 2, new_desc_blocks = 4
The filesystem on /dev/sda1 is now 7837849 (4k) blocks long.
```

Confirm size change and fstab 
```
# cat /proc/partitions
major minor  #blocks  name
   8        0   31457280 sda
   8        1   31351398 sda1
# cat /etc/fstab |grep UUID
UUID=b1162a3b-592a-42b4-8ee1-ec82f3d58de2 /                       ext4    defaults        1 1
# blkid |grep sda
/dev/sda1: UUID="b1162a3b-592a-42b4-8ee1-ec82f3d58de2" TYPE="ext4" PARTUUID="20df31a5-01"
```

If UUID changed then update fstab, if not you are good to go after a reboot.

# setting up the centos ansible control vm

Firewall settings 
(disable if on, at least for now)
```
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
```

Enable Firewall when done OR disable permanantley
```
systemctl enable firewalld
OR
systemctl mask --now firewalld
```

Install EPEL for CentOS S9
```
dnf config-manager --set-enabled crb
dnf -y install epel-release epel-next-release
dnf -y update
```

Quality of life
```
dnf -y install git vim net-tools traceroute htop python3-pip
```

Install dev toolkit (in case not all installed with vboxguest above)
```
dnf -y install gcc kernel-devel kernel-headers make cmake bzip2 perl
```

Install Putty from source
```
curl https://the.earth.li/~sgtatham/putty/0.78/putty-0.78.tar.gz --output putty-0.78.tar.gz
tar -xvf putty-0.78.tar.gz
cd putty-0.78/
cmake .
cmake --build .
cmake --build . --target install
# Test
puttygen -V
```

Install Ansible
```
dnf -y install ansible
dnf -y install podman
python -m pip install ansible-navigator
```

Run ansible-navigator for first time pull of ee's
Note may not be in roots path and should be needed as root
```
ansible-navigator
```

On CentOS this will pull the execution environment ```creator-ee``` which has the following included:
```
 0│---
 1│ansible:
 2│  collections:
 3│    details:
 4│      ansible.posix: 1.4.0
 5│      ansible.windows: 1.11.1
 6│      awx.awx: 21.7.0
 7│      containers.podman: 1.9.4
 8│      kubernetes.core: 2.3.2
 9│      redhatinsights.insights: 1.0.7
10│      theforeman.foreman: 3.6.0
11│  version:
12│    details: ansible [core 2.13.4]
```

