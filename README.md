# ceres_awx
AWX server provisioning for local and cloud

The goal of this project is to build three distinct AWX environments to cover dev, qa, and prod use cases.

*  DEV - AWX in a single VM on a local machine (Virtualbox hypervisor provisioned with Vagrant).
*  QA - AWX in a single IaaS VM and some PaaS services on Microsoft Azure.
*  PROD - AWX fully distributed IaaS/PaaS environment on Microsoft Azure.

## Local Environment

Since DEV will be on a local machine it is important to note the local environment this was tested with so you can make adjustments for your own local environment.

Here is the local environment this was tested with:

*  Host OS: Windows 10
*  VirtualBox version 7.0.6
*  Vagrant version 2.3.4
*  Git for Windows 2.37.3
*  VSCode 1.75.0
*  PuTTy 0.78

I do testing on two different machines (not at the same time) with the setup above using MS OneDrive to sync this folder between them.

Note that I do not run windows subsystem for linux as it has had conflicts with virtualbox in the past (not sure if those were ever resolved).

Vagrant does not like OneDrive sharing the .vagrant directory where it keeps its local system configuration data.
Rather than configure OneDrive to ignore that one folder (which seemed overly complex to do) I created some helper bash scripts I can run in a Git Bash shell that backup and restore the .vagrant folder on each machine.
These scripts are named ```xstart.sh``` and ```xquit.sh``` since I execute them at the start and end of testing on each machine.
These scripts also take care of the vagrant up and halt of my ansible control vms since I am lazy.

Since I want to use PuTTy to connect to the vagrant managed virtualbox VMs I wrote a script to copy and convert the vagrant ssh keys to the PuTTy ppk format.
This script ```vkeyconvert.sh``` will only work from a linux vm (not Git Bash or WSL) since the windows version of puttygen does not support CLI options the way the linux version does.
So, when I first connect to my ansible control vm I do so via the vagrant ssh method and then I install putty on it (see [Notes.md](Notes.md) for details on my ansible control vm config).
Then from the ansible control vm I can cd to the shared folder /vagrant and execute the script which generates the ppk keys for all the vagrant vms.

## Ansible Execution Environments

I plan to use Ansible Navigator on my ansible control vms to execute the AWX playbooks here since I like that it uses execution environments (just like AWX does).

IMHO EE's are much easier to deal with than setting up python virtual environments and controlling where collections get installed for each project and dealing with version conflicts.

To allow for the easy creation of local custom execution environments I created an ansible playbook and config files in the [build-ee](./build-ee/) directory which has its own [README](./build-ee/README.md) file explaining its use.


