# -*- mode: ruby -*-
# vi: set ft=ruby :
#
# Vagranfile for ceresawx automation platform
#
# Define Server Variables Here
servers=[
  {
    :hostname => "ceres-a",
    :log => "logs/ceres-a-console.log",
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
    :log => "logs/ceres-b-console.log",
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
    :log => "logs/ceres-c-console.log",
    :ip => "192.168.65.23",
    :box => "CentOS-Stream-Vagrant-9-20230123.0.x86_64",
    :boxurl => "https://cloud.centos.org/centos/9-stream/x86_64/images/CentOS-Stream-Vagrant-9-20230123.0.x86_64.vagrant-virtualbox.box",
    :ram => 16384,
    :vram => 16,
    :cpu => 4,
    :fwdguest => 80,
    :fwdhost => 8023
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
            node.vm.hostname = machine[:hostname]
            node.vm.network "private_network", ip: machine[:ip]
            node.vm.network "forwarded_port", guest: machine[:fwdguest], host: machine[:fwdhost]
            node.vm.provider "virtualbox" do |vb|
                vb.customize [
                  "modifyvm", :id,
                  "--vram", machine[:vram],
                  "--memory", machine[:ram],
                  "--cpus", machine[:cpu],
                  "--uartmode1", "file", File.join(Dir.pwd, machine[:log])
                ]
            end
            node.vm.synced_folder ".", "/vagrant", owner: "vagrant", group: "vagrant", mount_options: ["dmode=700,fmode=700"]
        end
    end
end
