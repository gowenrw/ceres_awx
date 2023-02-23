# ceres_awx

AWX server provisioning for local and cloud

The main goal of this project is to automate provisioning of several distinct Ansible AWX configurations (which cover dev, and qa use cases - maybe a prod use case in the future).

A secondary goal is to automate the creation of custom Ansible execution environments for use with ansible-navigator and Ansible AWX and to encourage the use of ansible-navigator versus ansible-playbook for running jobs.

A tertiary goal is to use current Redhat OS's for these servers, both local and cloud.
There are several projects out there that automate AWX on older (now unsupported) CentOS 8 or lower.
This project will use CentOS Stream 9 locally and Redhat Enterprise Linux 9 in the cloud.

A final goal is to meet the first two goals in a way that is accessible to those with limited Ansible knowledge (i.e., lots of documentation and examples).

These are the Ansible AWX configurations this project should automate provisioning for:
* DEV - AWX in a single VM on a local machine
  * The local VM needs to be provisioned manually prior to these AWX automation jobs
  * Has been tested with Virtualbox as the local hypervisor using Vagrant for local VM provisioning
  * Automation will install everything for a fully functional AWX system on that local VM.
* QA - AWX in a single IaaS VM on Microsoft Azure.
  * This should automate the provisioning of the AWX VM and its network landing zone in azure
  * Azure details will need to be provided for these automation jobs
  * An Azure AD Service Principal (SPN) account (with contributor access to a RG) will be needed
  * Automation will install everything for a fully functional AWX system as per the phases above.

In the future we will look at a production use case using these parameters:
* PROD - AWX distributed IaaS/PaaS environment on Microsoft Azure.
  * This job should provision a PaaS Kubernetes service, a PaaS external database, and IaaS VMs as needed.
  * The Azure resource group needs to be provisioned prior to these AWX automation jobs
    * Note that unlike QA, this automation will create its landing zone (VNET/Subnet(s)/etc.) in the RG
  * An Azure AD Service Principal (SPN) account (with access to the RG) is needed by these AWX automation jobs
  * Automation will provision Azure resources installing everything for a fully functional HA AWX system.

Currently we have bare bones working DEV and QA automation.
Need to tweak many things and add some post provisioning configurations.

# Git Submodules

This project makes use of git submodules.
So, to pull all the submodules down as part of the clone use the ```--recursive``` option.

Example:
```
git clone --recursive https://github.com/gowenrw/ceres_awx.git
```

If you cloned without the recursive option you can pull the submodules with this:
```
git submodule update --init --recursive
```

If you forked this project and want to pull a newer version of a submodule here is how its done.
From within the project directory cd to the submodule dir and pull from main then cd .. and add/commit/push.
Example:
```
cd build-ee; git pull origin main
cd ..; git add build-ee; git commit -a -m 'updated build-ee'; git push
```

# How To Use This Project

## Quick Start

Want to get started quickly?

Check out the [QUICKSTART.md](./QUICKSTART.md) document.

## Local Environments

You will need to setup your local environment for running Ansible (i.e., Ansible control node) and your local environment for spinning up local vms if needed for AWX DEV provisioning and/or an Ansible control node.

If you are using a linux host these two local environments may be the same.
But if you are using a Windows host then these two local environments will be different as Ansible cannot be run nativley on Windows.

I use a Windows host with a linux vm for my Ansible control node.  You can see [my local environment details below](#my-local-environment).
This includes details about the [ansible.cfg](./ansible.cfg) file and [ansible-navigator.yml](./ansible-navigator.yml) file provided here and what they do.

This project has been optimized for use with ```ansible-navigator``` to execute the Ansible playbooks for provisioning AWX.

If you plan to use ```ansible-navigator``` then you need to either [build your local execution environment using the scripts provided](#ansible-execution-environments) or pull down the pre-built execution environment using the following command.
```
podman pull docker.io/altbier/cloud-creator-awx-ee:latest
```
Note that ansible-navigator will pull this image for you the first time it is run unless you changed its configuration file.

If you plan to use ```ansible-playbook``` then you need to add the collections and python modules to your local environment, and you will need to adjust the example code provided as needed.

## Inventory File

This project has an inventory file named [ceres.inventory.yml](./ceres.inventory.yml) which contans the details Ansible needs about the hosts we will automate against.

You will need to modify this file to incorporate the hosts that meet your needs.

## Group Variable File

This project makes use of a group variable file [group_vars/all.yml](./group_vars/all.yml) which contains variables that will be included regardless which inventory host is being called.

Items that are stored here are ansible vault encrypted secrets for things like Azure AD Service Principal (SPN) credentials, or sudo passwords.

Note that this is not an ansible-vault encrypted file, but rather a normal yaml file which contains ansible-vault encrypted variable values.
So the commands ```ansible-vault edit``` and ```ansible-vault view``` will not work on this file.
Instead you must use ```ansible-vault encrypt_string``` to add/change variable values and a debug job like this one to view existing variable values:
```
ansible localhost -m ansible.builtin.debug -a var="test_sudo_pass" -e "@./group_vars/all.yml"
```

You will need to modify this file to incorporate the credentials and other items that meet your needs.

## Roles and Role Variables

There are several Ansible [roles](./roles/) included in this project that are called in different ways using playbooks.

You should not need to modify any of the code in these roles.
But you may want to modify variables in your playbooks to affect the behavior of these roles.

The variables that each role uses are located in that roles defaults/main.yml and/or vars/main.yml files.
You can inspect these files to determine which variable names are used to set which values and then include that variable name with a new value in your playbook.

The Ansible variable order of precedence dictates that a variable defined in a playbook will take precedence over (i.e., overwrite the value of) that same variable name defined in a role.
Here is a simplified variable order of precedence list as applies to this project:
* Vars in ./playbook.yml take precedence over ./roles/role-name/vars/main.yml
* Vars in ./roles/role-name/vars/main.yml take precedence over ./roles/role-name/defaults/main.yml
* Vars in ./roles/role-name/defaults/main.yml take precedence over ./group_vars/all.yml

## Playbooks

There are several Ansible playbooks included in this project that are examples of how to perform various automation jobs.
These playbooks are all named ceres-playbook-<jobname>.yml where <jobname> refers to the automation job that playbook will execute.

There are several testing playbooks that contain extra variables:
* [ceres.test.playbook.dev.yml](ceres.test.playbook.dev.yml) - Testing Playbook for DEV (local VM)
* [ceres.test.playbook.azsetup.yml](ceres.test.playbook.azsetup.yml) - Testing Playbook for Azure Setup (create Azure VM)
* [ceres.test.playbook.qa.yml](ceres.test.playbook.qa.yml) - Testing Playbook for QA (Azure VM)

Here are the main playbooks used in this project:
* [ceres.playbook.dev.yml](ceres.playbook.dev.yml) - Playbook for DEV (local VM)
* [ceres.playbook.azsetup.yml](ceres.playbook.azsetup.yml) - Playbook for Azure Setup (create Azure VM)
* [ceres.playbook.qa.yml](ceres.playbook.qa.yml) - Playbook for QA (Azure VM)

Each of these playbooks will have embedded comment text explaining what it is doing.

These playbook files can be modified or copied / changed to meet your needs.
At a minimum you will need to verify the proper inventory host names are being called.

## Running the Automation Jobs

Assuming [your local environments](#local-environments) have been properly configured this is how you would run a playbook:
```
ansible-navigator run ceres.test.playbook.dev.yml
```

Other playbooks would be run the same way, just replace the playbook filename.

# My Local Environment

Since AWX DEV will be on a local machine it is important to note the local environment this was tested with so you can make adjustments for your own local environment.

Here is the local environment this was tested with:

* Host OS: Windows 10
* VirtualBox version 7.0.6
* Vagrant version 2.3.4
* Git for Windows 2.37.3
* VSCode 1.75.0
* PuTTy 0.78

I do testing on two different machines (not at the same time) with the setup above using MS OneDrive to sync this folder between them.

Note that I do not run windows subsystem for linux as it has had conflicts with virtualbox in the past (not sure if those were ever resolved).

Since Ansible cannot be run nativley on Windows I have local VMs configured in Vagrant to use as Ansible control nodes (i.e., this is where I run the Ansible code for the AWX automation).

Vagrant does not like my OneDrive sharing the .vagrant directory where it keeps its local system configuration data.
Rather than configure OneDrive to ignore that one folder (which seemed overly complex to do) I created some helper bash scripts I can run in a Git Bash shell that backup and restore the .vagrant folder on each machine.
These scripts are named ```xstart.sh``` and ```xquit.sh``` since I execute them at the start and end of testing on each machine.
These scripts also take care of the vagrant up and halt of my Ansible control vms since I am lazy.
Note: these scripts lookup the Windows Hostname for conditionals and will need to be modified for use elsewhere.

Since I want to use PuTTy to connect to the vagrant managed virtualbox VMs I wrote a script to copy and convert the vagrant ssh keys to the PuTTy ppk format.
This script ```vkeyconvert.sh``` will only work from a linux vm (not Git Bash or WSL) since the windows version of puttygen does not support CLI options the way the linux version does.
So, when I first connect to my Ansible control vm I do so via the vagrant ssh method and then I install putty on it (see [Notes.md](./NOTES.md) for details on my Ansible control vm config).
Then from the Ansible control vm I can clone this git repository and execute the script which generates the ppk keys for all the vagrant vms.

On my local Ansible control node vm I perform a seperate git clone of this project for running these jobs.
While it is possible to use the shared folder, given the file and permission differences between the windows host and the linux guest this usually causes issues.
So, it is better to work with a linux native copy on the linux vm.

## ansible.cfg configuration file

The ansible config file ```ansible.cfg``` included with this project is not strictly necessary but contains a couple of conviniece items.

### ansible.cfg Vault Password File

The following config looks for a local file named ```.ansible-vault.private_key``` that contains the vault key. 
```
vault_password_file: ./.ansible-vault.private_key
```

This prevents you from being prompted for your vault key or needing to pass the ```--vault-password-file <filename>``` command line option.

The .gitignore file for this project is set to ignore this file to prevent the key from being included in the repository.

It is important to note that a vault keyfile can be located outside the git repository directory, typically in a home directory referenced like ```~/.ansible-vault.private_key```.
The main reason this project uses a local vault keyfile is because I use different vault keys for each of my projects which I believe to be a best practice (so if one project's key is compromised it does not impact others).
Additionally ansible-navigator has an issue with a non-local vault key file since only the current directory it is launched from is copied to the execution environment container it uses (and your home directory isn't in that container).

### ansible.cfg Inventory File

The following config looks for a local file named ```ceres.inventory.yml``` that contains the Ansible inventory information.
```
inventory = ./ceres.inventory.yml
```

This prevents you from needing to pass the ```-i <filename>``` command line option.

## ansible-navigator.yml file

The ansible-navigator config file ```ansible-navigator.yml``` included with this project is needed for using ```ansible-navigator``` instead of ```ansible-playbook``` to run playbooks.

If you plan to use ansible-playbook to run the playbooks in this project then you will need to install the required galaxy collections and configure your python virtual environment with all the modules required by those collections.

If you plan to use ```ansible-navigator``` to run the playbooks in this project then you need to either [build your local execution environment using the scripts provided](#ansible-execution-environments) or pull down the pre-built execution environment using the following command.
```
podman pull docker.io/altbier/cloud-creator-awx-ee:latest
```
Note that ansible-navigator will pull this image for you the first time it is run unless you changed its configuration file.

This config file set up ansible-navigator to:
* Use the local execution environment image named ```cloud-creator-awx-ee:latest``` using podman to pull it
* Use a local log file named ```_ansible-navigator.log``` for troubleshooting
* Disable the creation of playbook artifact files
* Set the mode to ```stdout`` instead of the default of interactive

# Ansible Execution Environments

This project has been optimized for use with ```ansible-navigator``` to execute the Ansible playbooks for provisioning AWX.

Ansible Navigator uses execution environments just like AWX does.

An Execution Environment (EE) is a container that has all the galaxy collections and python modules required to execute Ansible playbooks removing any dependencies on the local enviroment.

IMHO EE's are much easier to deal with than setting up local python virtual environments and controlling where collections get installed for each project and dealing with version conflicts.

To allow for the easy creation of local custom execution environments I created an Ansible playbook and config files in the [build-ee](./build-ee/) directory which has its own [README](./build-ee/README.md) file explaining its use.

Note: the [build-ee](./build-ee/) directory was broken out into its own repo and is now a git submodule here.
So if that directory is empty when you clone this repo you might need to pull it with this command:
```
git submodule update --init --recursive
```

The [build-ee](./build-ee/) config files have been set to include all the [galaxy collections and thier required python modules](./build-ee/config-ee-galaxy-requirements.yml) as well as some [additional python modules](./build-ee/config-ee-python-requirements.txt) that exist in the ansible provided ```creator-ee``` and ```awx-ee``` images along with the additional requirements for this project.

Note that building your own execution enviornment is optional in case you wish to tweak the contents.

For the AWX playbooks here you can simply pull the pre-built ee from docker hub with this command:
```
podman pull docker.io/altbier/cloud-creator-awx-ee:latest
```
Note that ansible-navigator will pull this image for you the first time it is run unless you changed its configuration file.
