# ceres_awx
AWX server provisioning for local and cloud

# Centos stream on vagrant/vbox notes

Install EPEL for CentOS S8
```
dnf config-manager --set-enabled powertools
dnf install epel-release epel-next-release
dnf update
```

Install EPEL for CentOS S9
```
dnf config-manager --set-enabled crb
dnf -y install epel-release epel-next-release
dnf -y update
```

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
```
vagrant plugin install vagrant-vbguest
vagrant vbguest --status vm-name
vagrant vbguest --do install
```

Add to Vagrantfile for plugin
```
# Uncomment to disable update
# node.vbguest.auto_update = false
# Uncomment to force kernel update for centos
node.vbguest.installer_options = { allow_kernel_upgrade: true }
```

Firewall settings
```
firewall-cmd --state
systemctl stop firewalld
systemctl disable firewalld
systemctl mask --now firewalld
```
