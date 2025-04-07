# ceres_awx

Ansible AWX server provisioning

The main goal of this project is to automate provisioning of Ansible AWX on a VM located on-premise or in the cloud.

A secondary goal is to automate the provisioning of Ansible AWX in a cloud managed container service (e.g., Azure AKS, AWS ECS).

These are the Ansible AWX configurations this project should automate provisioning for:

* Any_VM - AWX in a single VM (or pyisical machine) located anywhere (e.g., local, on-premise, cloud)
  * The VM needs to be provisioned prior to these ceres_awx automation jobs running (no provisioning scripts provided)
  * Connectivity via SSH should be allowed and confirmed from the control platform where you are running the cerex_awx automation jobs to the target VM where you wish AWX installed.
  * The file ```ceres.inventory.yml``` will need to be updated with the SSH key and other VM details
  * The supported VM OS Types should be RHEL 9, and CentOS Stream 9
  * Testing will be done with the supported OS types, any other OS may require tweaks to the code
  * Automation will install everything for a fully functional AWX system on that VM.
* AZ_AKS (Future) - AWX in an Azure Kubernetes Service cluster provisioned via our automation scripts.
  * This should automate the provisioning of the AWX services in its AKS cluster landing zone in azure
  * Azure details will need to be provided for these automation jobs
  * An Azure AD Service Principal (SPN) account (with contributor access to a RG) will be needed
  * Automation will install everything for a fully functional AWX system.

As this is a revamp of an old project none of the above are fully functional at this time.

# How To Use This Project

## Local Environment

You will need to setup your local environment for running Ansible (i.e., Ansible control node).

Given that Ansible does not run nativley on Windows this will need to be a Linux environment such as on a VM or WSL.

## Local Environment Requirements

For the Ansible cotrol node local environment (which needs to be Linux) you will need the following installed:
  * python v3
  * python pip v3
  * podman or docker
  * ansible-core
  * ansible-navigator

This project has been optimized for use with ```ansible-navigator``` to execute the Ansible playbooks for provisioning AWX.

Running ```ansible-navigator``` in the project directory will automatically pull the EE image [altbier/cloud-creator-awx-ee](https://hub.docker.com/repository/docker/altbier/cloud-creator-awx-ee) for you the first time it is run unless you change the ```ansible-navigator.yml``` configuration file.

If you plan to use ```ansible-playbook``` then you need to add the collections and python modules to your local environment, and you will need to adjust the example code provided as needed.

The [ansible.cfg](./ansible.cfg) file is set up to look for an ansible vault file named ```.ansible-vault.private_key``` so regardless of weather or not you plan on using ansible-vault you will either need to create that file with some random text in it or remove that configuration line to prevent ansible from throwing errors.  The file ```.ansible-vault.private_key``` is where you should place your vault key if you are going to encrypt secrets such as credentials.  This file has been added to the ```.gitignore``` file to prevent it from being anything but a local file which is why it needs to be created or the ```ansible.cfg``` modified not to look for it.

The playbooks have been configured to call a file named ```.vaultfile.yml``` and look for certain credential variables configured in that file.  If you are planning on using ansible vault to encrypt secrets via the key file explained above, then you should create the file ```.vaultfile.yml``` add the credential variables there and vault encrypt it.  More info on how to [use ansible vault can be found here](https://docs.ansible.com/ansible/latest/vault_guide/index.html).  If you are not planning to use encrypted secrets (not recommended even if you are working local only) then you will need to comment out the call to ```.vaultfile.yml``` and add your credential information directly in the playbooks.

## Execution Environment

The default execution environment used by this project is this one:
[altbier/cloud-creator-awx-ee](https://hub.docker.com/repository/docker/altbier/cloud-creator-awx-ee)

It should be pulled automatically by ansible-navigator based on the included config.
This comman will manually pull it:
```bash
podman pull docker.io/altbier/cloud-creator-awx-ee:latest
```

This EE was custom build based on what the default AWX EE had plus some additional cloud tools.

If you wish to custom build your own EE you can use the code I created for building the above EE which is in this repository:
[gowenrw/build-ee](https://github.com/gowenrw/build-ee)

## Inventory File

This project has an inventory file named [ceres.inventory.yml](./ceres.inventory.yml) which contans the details Ansible needs about the hosts we will automate against.

You will need to modify this file to accomodate your AWX installation.

Several examples are commented out here so you can uncomment the one that meets your needs or create your own.

Note that several different key file extensions have been added to the ```.gitignore``` file to prevent accidental upload of keys to a repository should they be stored locally in this project directory (as they are referenced in the inventory examples).  It is not necessary to store keys in this project directory at all, you just need to provide a full path to the key file in the inventory file key reference.

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

## Playbooks

There are several Ansible playbooks included in this project that are examples of how to perform various automation jobs.
These playbooks are all named ceres-playbook-<jobname>.yml where <jobname> refers to the automation job that playbook will execute.

Here are the main playbooks used in this project (only one now, but more to follow soon):
* [ceres.playbook.any_vm.yml](ceres.playbook.any_vm.yml) - Playbook to deploy AWX on Any VM

Each playbook will have embedded comment text explaining what it is doing.

These playbook files can be modified or copied / changed to meet your needs.

At a minimum you will need to verify the proper inventory host and credential variables are set.

# Running the Automation Jobs

Assuming your local environment have been properly configured this is how you would run a playbook:
```
ansible-navigator run ceres.playbook.any_vm.yml
```

Other playbooks would be run the same way, just replace the playbook filename.
