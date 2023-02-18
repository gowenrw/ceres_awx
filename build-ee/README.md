# build-ee ansible playbook and artifacts

A quick and dirty ansible playbook and artifacts to build a local execution environment (for ansible-navigator to consume) and optionally push that ee to a container registry (for AWX/AAP to consume).

This was written to be run from ansible core using ```ansible-playbook``` and not navigator.

## Configuring

These are the configuration files
* [config-ee.yml](./config-ee.yml)
  * This is the main config file that calls the other two
* [config-ee-galaxy-requirements.yml](./config-ee-galaxy-requirements.yml)
  * This is the list of ansible collections to install in the ee
  * Python modules required by these collections will also be installed
  * Collections without a version will pull the latest
* [config-ee-python-requirements.txt](./config-ee-python-requirements.txt)
  * This is the list of Python modules to install in addition to above
  * Modules without a version will pull the latest
* [build-vars.yml](./build-vars.yml)
  * This is the variable file for the build-ee playbook
  * There are several settings that can be tweaked here
  * The version here is used as a tag when pushing to a registry

## Running

Once the configuration files are set simple execute the build-ee playbook
```
ansible-playbook build-ee.yml
```

Note that I am using ansible core's ```ansible-playbook``` to run this playbook.
This is because we need the execution of this build to stay in the local environment.
If we were to use ansible-navigator it's use of an execution environment would cause issues.
