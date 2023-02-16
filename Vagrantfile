# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagranfile for ceresawx automation platform
#
# Plugin requirment notes: 
# Some boxes dont have vbguest additions so the plugin vagrant-vbguest installs them.
# Some box images have small disks so the plugin vagrant-disksize resizes them
# Note that resizing the disk does not resize the partition on that disk, use parted
#
# CentOS Stream box image:
# CentOS 9 Stream URL - https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box
#
# Define Server Variables Here
servers=[
  {
    :hostname => "ceres-a",
    :log => "ceres-a-console.log",
    :ip => "192.168.65.21",
    :box => "CentOS-Stream-Vagrant-9-20230207.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box",
    :ram => 8192,
    :vram => 16,
    :cpu => 2,
    :disksize => "20GB",
    :fwdguest => 80,
    :fwdhost => 8021
  },
  {
    :hostname => "ceres-b",
    :log => "ceres-b-console.log",
    :ip => "192.168.65.22",
    :box => "CentOS-Stream-Vagrant-9-20230207.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box",
    :ram => 4096,
    :vram => 16,
    :cpu => 2,
    :disksize => "20GB",
    :fwdguest => 80,
    :fwdhost => 8022
  },
  {
    :hostname => "ceres-c",
    :log => "ceres-c-console.log",
    :ip => "192.168.65.23",
    :box => "CentOS-Stream-Vagrant-9-20230207.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box",
    :ram => 2048,
    :vram => 16,
    :cpu => 2,
    :disksize => "15GB",
    :fwdguest => 80,
    :fwdhost => 8023
  },
  {
    :hostname => "ceres-ctrl",
    :log => "ceres-ctrl-console.log",
    :ip => "192.168.65.24",
    :box => "CentOS-Stream-Vagrant-9-20230207.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box",
    :ram => 4096,
    :vram => 16,
    :cpu => 2,
    :disksize => "30GB",
    :fwdguest => 80,
    :fwdhost => 8024
  },
  {
    :hostname => "ceres-rectal",
    :log => "ceres-rectal-console.log",
    :ip => "192.168.65.25",
    :box => "CentOS-Stream-Vagrant-9-20230207.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box",
    :ram => 4096,
    :vram => 16,
    :cpu => 2,
    :disksize => "30GB",
    :fwdguest => 80,
    :fwdhost => 8025
  },
  {
    :hostname => "ceres-tst",
    :log => "ceres-tst-console.log",
    :ip => "192.168.65.26",
    :box => "CentOS-Stream-Vagrant-9-20230207.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230207.0.x86_64.vagrant-virtualbox.box",
    :ram => 2048,
    :vram => 16,
    :cpu => 2,
    :disksize => "0", # Set to zero to prevent disk resizing
    :fwdguest => 80,
    :fwdhost => 8026
  }
]
#
# Call Vagrant
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    #
    # Install required vagrant plugins
    # To install plugins to the local project only uncomment this line
    # config.vagrant.plugins = ["vagrant-vbguest", "vagrant-disksize"]
    # To install plugins globally if not installed uncomment next 8 lines
    unless Vagrant.has_plugin?("vagrant-vbguest")
      system('vagrant plugin install vagrant-vbguest')
      exit system('vagrant', *ARGV)
    end
    unless Vagrant.has_plugin?("vagrant-disksize")
      system('vagrant plugin install vagrant-disksize')
      exit system('vagrant', *ARGV)
    end
    #
    # Configure Servers In A Loop
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.box_url = machine[:boxurl]
            # Uncomment below lines to change disk size if defined
            if machine[:disksize] != "0"
                node.disksize.size = machine[:disksize]
            end
            # Uncomment below line to disable vbguest install
            # node.vbguest.auto_update = false
            # Uncomment below line to allow kernel update for vbguest install
            node.vbguest.installer_options = { allow_kernel_upgrade: true }
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            node.vm.network "forwarded_port", guest: machine[:fwdguest], host: machine[:fwdhost]
            node.vm.provider "virtualbox" do |vb|
                vb.customize [
                  "modifyvm", :id,
                  "--vram", machine[:vram],
                  "--memory", machine[:ram],
                  "--cpus", machine[:cpu],
                  "--uart1", "0x3f8", "4",
                  "--uartmode1", "file", File.join(Dir.pwd, machine[:log])
                ]
            end
            # type:virtualbox works best but requires vbguest additions so might fail until installed
            node.vm.synced_folder ".", "/vagrant", type: "virtualbox", owner: "vagrant", group: "vagrant", mount_options: ["dmode=700,fmode=700"]
        end
    end
end
