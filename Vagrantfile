# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagranfile for ceresawx automation platform
#
# Note: Some boxes dont have the guest extension.  To install on load use this plugin
# vagrant plugin install vagrant-vbguest
#
# Define Server Variables Here
#
# CentOS 8 Stream - https://cloud.centos.org/centos/8-stream/x86_64/images/CentOS-Stream-Vagrant-8-20220913.0.x86_64.vagrant-virtualbox.box
# CentOS 9 Stream - https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box
#
servers=[
  {
    :hostname => "ceres-a",
    :log => "ceres-a-console.log",
    :ip => "192.168.65.21",
    :box => "CentOS-Stream-Vagrant-9-20230123.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box",
    :ram => 4096,
    :vram => 16,
    :cpu => 2,
    :fwdguest => 80,
    :fwdhost => 8021
  },
  {
    :hostname => "ceres-b",
    :log => "ceres-b-console.log",
    :ip => "192.168.65.22",
    :box => "CentOS-Stream-Vagrant-9-20230123.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box",
    :ram => 8192,
    :vram => 16,
    :cpu => 4,
    :fwdguest => 80,
    :fwdhost => 8022
  },
  {
    :hostname => "ceres-c",
    :log => "ceres-c-console.log",
    :ip => "192.168.65.23",
    :box => "CentOS-Stream-Vagrant-9-20230123.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box",
    :ram => 16384,
    :vram => 16,
    :cpu => 4,
    :fwdguest => 80,
    :fwdhost => 8023
  },
  {
    :hostname => "ceres-datass",
    :log => "ceres-datass-console.log",
    :ip => "192.168.65.24",
    :box => "CentOS-Stream-Vagrant-9-20230123.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box",
    :ram => 2048,
    :vram => 16,
    :cpu => 1,
    :fwdguest => 80,
    :fwdhost => 8024
  },
  {
    :hostname => "ceres-rectal",
    :log => "ceres-rectal-console.log",
    :ip => "192.168.65.25",
    :box => "CentOS-Stream-Vagrant-9-20230123.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box",
    :ram => 4096,
    :vram => 16,
    :cpu => 2,
    :fwdguest => 80,
    :fwdhost => 8025
  }
]
#
# Configure Servers In A Loop
VAGRANTFILE_API_VERSION = "2"
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    servers.each do |machine|
        config.vm.define machine[:hostname] do |node|
            node.vm.box = machine[:box]
            node.vm.box_url = machine[:boxurl]
            # Uncomment to disable update
            # node.vbguest.auto_update = false
            # Uncomment to force kernel update for centos
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
            node.vm.synced_folder ".", "/vagrant", type: "virtualbox", owner: "vagrant", group: "vagrant", mount_options: ["dmode=700,fmode=700"]
        end
    end
end
