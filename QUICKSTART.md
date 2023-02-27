# ceres_awx quickstart

This document was written for the impatient who want to just jump in now and RTFM later.

# Overview

The basics of what this project will do for you is spin up a functional Ansible AWX system on either a local vm (which we are calling DEV) or on an Azure hosted vm (which we are calling QA).

You can spin up your own target vm (locally or in Azure) to run the automation playbooks against.
Or you can use the tools here to spin up a local vm using vagrant/virtualbox or an Azure vm using a seperate azsetup automation playbook.

# Local Environment

There are some minimum things you are going to need to run the automation playbooks here:
* Linux - Ansible only runs in linux so on a Windows host you need a linux vm as your local environment
* Linux Package Requirements - How you install these differs based on your linux system, google is your friend
  * python v3
  * python pip v3
  * podman or docker
  * ansible-core
  * ansible-navigator
* Execution Environment Container with all required ansible collections - Use the one I created or create your own
  * This one will work: https://hub.docker.com/r/altbier/cloud-creator-awx-ee
  * The ansible-navigator.yml config file will make ansible-navigator pull this EE down on first launch

If you wish to spin up local vms using the [Vagrantfile](./Vagrantfile) included in this project you will need:
* VirtualBox version 7+ (tested with 7.0.6, 6.x versions might work but not tested)
* Vagrant version 2.3+ (tested with 2.3.4, 2.2.x might also work but 2.1.x will fail)

The [ansible.cfg](./ansible.cfg) file is set up to look for an ansible vault file named ```.ansible-vault.private_key``` so regardless of weather or not you plan on using ansible-vault you will either need to create that file with some random text in it or remove that configuration line to prevent ansible from throwing errors.

# Target VM

We need a target VM to install AWX on.
This can be a local VM (for the DEV automation jobs) or an Azure VM (for the QA automation jobs).

If you are going to spin up your VM via some process not included here then skip ahead to [Lets Run This Shit](#lets-run-this-shit)

## Local VM

To spin up a local VM on VirtualBox using Vagrant just use the following command:
```
vagrant up ceres-c9
```

Nothing else needs to be provided to create this VM since all the configs are in the [Vagrantfile](./Vagrantfile)

When vagrant is done you will have a local VM named ceres-c9 running CentOS Stream 9 which is your target for AWX.

## Azure VM (and other required artifacts)

To spin up an Azure VM and its other required Azure resources (VNET/Subnet/etc.) will require some things.

You will need to do the following in your Azure account:
* View the subscription overview details
  * Take note of the following items we will need:
    * Azure Tenant ID (also known as Parent Management Group)
    * Azure Subscription ID
* Create a new empty resource group for use by this project
  * Take note of the following items we will need:
    * Azure Resource Group Name
* Create a new Azure AD Service Principal application for use by this project
  * In the portal this is done under Azure_AD -> App_Registrations -> +New_Registration
  * Take note of the following items we will need:
    * Application (Client) ID
* Create a new secret for the Service Principal
  * In the portal under App_Registration App view -> Certificates_&_Secrets -> +New_Client_Secret
  * Take note of the following items we will need:
    * Secret Value
* In the resource group IAM settings grant the service principal contributor access
  * In the portal under Resource_Group view -> Access_Control_IAM -> Role_Assignments -> +Add

The following variables will need to be populated with the values gathered above.
This can be done in either the file [group_vars/all.yml](./group_vars/all.yml) or in the file [ceres.playbook.azsetup.yml](./ceres.playbook.azsetup.yml)
* az_tenant_id
* az_subscription_id
* az_resource_group_name
* az_spn_client_id
* az_spn_secret

Now we are ready to run the azure setup automation.
Using the information provided, this automation will do the following:
* Create a Application Security Group (ASG)
* Create a Network Security Group (NSG) which makes use of the ASG
* Create a Virtual Network
* Create a Subnet which is associated with the NSG
* Create a Public IP
* Create a SSH Key Pair
* Create a VM in the Subnet using the Public IP and SSH Key
* Modify the [ceres.inventory.yml](./ceres.inventory.yml) file with the target VM details

Use the following to run the azure setup automation:
```
ansible-navigator run ceres.playbook.azsetup.yml
```

When ansible is done you should have an Azure VM named ceres-az01 running RHEL 9 which is your target for AWX.

# Lets Run This Shit

Now that we have a target VM to install AWX on we just need to run the automation to do that.

If you created your own VM via some process not included here then make sure you have updated the Ansible inventory file [ceres.inventory.yml](./ceres.inventory.yml) with the details of the target VM you created.

## DEV local VM AWX build

If you are building AWX on a local VM then run the DEV automation job with this command:
```
ansible-navigator run ceres.playbook.dev.yml
```

## QA Azure VM AWX build

If you are building AWX on an Azure VM then run the QA automation job with this command:
```
ansible-navigator run ceres.playbook.qa.yml
```

## Rerunning

These automation jobs are item potent, meaning they can be rerun without redoing all the tasks that were already completed sucessfully.

So, if there is an error or you with to change some settings you can make your changes and and rerun the job.
It will only run the tasks needed by the changes made, or continue tasks from where it failed.

## Connecting

When the job is completed, if there were no errors, you should be provided with connection details for both the Kubernetes Dashboard and the AWX UI.

These connection details will be saved in local files that start with CONNECT

This will provide you the URL link and credentials to connect to the server.

Enjoy!
