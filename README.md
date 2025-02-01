# ceres_awx

AWX server provisioning for local and cloud

The main goal of this project is to automate provisioning of Ansible AWX on a VM located on-premise or in the cloud.

A secondary goal is to automate the provisioning of Ansible AWX in a cloud managed container service (e.g., Azure AKS, AWS ECS).

A tertiary goal is to automate the creation of custom Ansible execution environments for use with ansible-navigator and Ansible AWX and to encourage the use of ansible-navigator versus ansible-playbook for running CLI jobs. 

NOTE THIS GOAL MOVED TO MY [build-ee REPOSITORY](https://github.com/gowenrw/build-ee) Project which is called as a submodule here.

A final goal is to make this code accessible to those with limited Ansible knowledge (i.e., lots of documentation and examples).

These are the Ansible AWX configurations this project should automate provisioning for:

* MYVM - AWX in a single VM (or pyisical machine) located anywhere (e.g., local, on-premise, cloud)
  * The VM needs to be provisioned prior to these ceres_awx automation jobs running (no provisioning scripts provided)
  * Connectivity via SSH should be allowed and confirmed from the control platform where you are running the cerex_awx automation jobs to the target VM where you wish AWX installed.
  * The file ```ceres.inventory.yml``` will need to be updated with the SSH key and other VM details
  * The supported VM OS Types should be RHEL 9, CentOS Stream 9, and Ubuntu 24.04
  * Testing will be done with the supported OS types, any other OS may require tweaks to the code
  * Automation will install everything for a fully functional AWX system on that VM.
* AZVM - AWX in a single IaaS VM on Microsoft Azure provisioned via our automation scripts.
  * This should automate the provisioning of the AWX VM and its network landing zone in azure
  * Azure details will need to be provided for these automation jobs
  * An Azure AD Service Principal (SPN) account (with contributor access to a RG) will be needed
  * Automation will install everything for a fully functional AWX system.
* AZAKS - AWX in an Azure Kubernetes Service cluster provisioned via our automation scripts.
  * This should automate the provisioning of the AWX services in its AKS cluster landing zone in azure
  * Azure details will need to be provided for these automation jobs
  * An Azure AD Service Principal (SPN) account (with contributor access to a RG) will be needed
  * Automation will install everything for a fully functional AWX system.

As this is a revamp of an old project none of the above are fully functional at this time.

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

## Local Environments

You will need to setup your local environment for running Ansible (i.e., Ansible control node).

Given that Ansible does not run nativley on Windows this will need to be a Linux environment such as on a VM or WSL.

### Local Environment for Ansible

I use a Linux vm for my Ansible control node.  You can see [my local environment details below](#my-local-environment).
This includes details about the [ansible.cfg](./ansible.cfg) file and [ansible-navigator.yml](./ansible-navigator.yml) file provided here and what they do.

For the Ansible cotrol node local environment (which needs to be Linux) you will need the following installed:
  * python v3
  * python pip v3
  * podman or docker
  * ansible-core
  * ansible-navigator

This project has been optimized for use with ```ansible-navigator``` to execute the Ansible playbooks for provisioning AWX.

If you plan to use ```ansible-navigator``` then you need to either [build your local execution environment using the scripts provided](#ansible-execution-environments) or you can [use my pre-built execution environment](https://hub.docker.com/r/altbier/cloud-creator-awx-ee).

To pull down a pre-built execution environment using podman this is what the command would look like:
```
podman pull docker.io/altbier/cloud-creator-awx-ee:latest
```

Note that running ```ansible-navigator``` in the project directory will automatically pull this EE image for you the first time it is run unless you changed its configuration file.

If you plan to use ```ansible-playbook``` then you need to add the collections and python modules to your local environment, and you will need to adjust the example code provided as needed.

The [ansible.cfg](./ansible.cfg) file is set up to look for an ansible vault file named ```.ansible-vault.private_key``` so regardless of weather or not you plan on using ansible-vault you will either need to create that file with some random text in it or remove that configuration line to prevent ansible from throwing errors.

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
* Vars in ./*playbook.yml take precedence over ./roles/role-name/vars/main.yml
* Vars in ./roles/role-name/vars/main.yml take precedence over ./roles/role-name/defaults/main.yml
* Vars in ./roles/role-name/defaults/main.yml take precedence over ./group_vars/all.yml

## Playbooks

There are several Ansible playbooks included in this project that are examples of how to perform various automation jobs.
These playbooks are all named ceres-playbook-<jobname>.yml where <jobname> refers to the automation job that playbook will execute.

Here are the main playbooks used in this project:
* [ceres.playbook.azsetup.yml](ceres.playbook.azsetup.yml) - Playbook for Azure Setup (provision an Azure VM)
* [ceres.playbook.azvm.yml](ceres.playbook.azvm.yml) - Playbook to deploy AWX on the Azure VM from azsetup
* [ceres.playbook.myvm.yml](ceres.playbook.myvm.yml) - Playbook to deploy AWX on any VM provisioned by you

Each of these playbooks will have embedded comment text explaining what it is doing.

These playbook files can be modified or copied / changed to meet your needs.
At a minimum you will need to verify the proper inventory host names are being called.

## Running the Automation Jobs

Assuming [your local environments](#local-environments) have been properly configured this is how you would run a playbook:
```
ansible-navigator run ceres.playbook.myvm.yml
```

Other playbooks would be run the same way, just replace the playbook filename.

# My Local Environment

I use an Ubuntu VM as my Ansible control node and have its local environment set up with ansible-core and ansible-navigator and podman using a set up automation script not contained in this repo.
The details of this are not too important only that I keep both ansible-core and ansible-navigator up to date with the most recent version available.

All the ansible collections and python libraries needed are contained in the execution environment container that is used by ansible-navigator, so there is no need to install those locally.

On my local Ansible control node vm I perform a git clone of this project for running these jobs using ansible-navigator and its EE which is defined in its configuration file in this repo.

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

To allow for the easy creation of local custom execution environments I created an Ansible playbook and config files in the ```build-ee``` directory which has its own [README](https://github.com/gowenrw/build-ee/blob/main/README.md) file explaining its use.

Note: the [build-ee](https://github.com/gowenrw/build-ee) directory was broken out into its own repo and is now a git submodule here.
So if that directory is empty when you clone this repo you might need to pull it with this command:
```
git submodule update --init --recursive
```

The ```build-ee``` config files have been set to include all the [galaxy collections and thier required python modules](https://github.com/gowenrw/build-ee/blob/main/config-ee-galaxy-requirements.yml) as well as some [additional python modules](https://github.com/gowenrw/build-ee/blob/main/config-ee-python-requirements.txt) that exist in the ansible provided ```creator-ee``` and ```awx-ee``` images along with the additional requirements for this project.

Note that building your own execution enviornment is optional in case you wish to tweak the contents.

For the AWX playbooks here you can simply pull the pre-built ee from docker hub with this command:
```
podman pull docker.io/altbier/cloud-creator-awx-ee:latest
```
Note that ansible-navigator will pull this image for you the first time it is run unless you changed its configuration file.
