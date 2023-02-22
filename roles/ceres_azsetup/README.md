ceres_azsetup
============

This role will setup an azure landing zone (e.g., vnet/subnet/nsg/etc.) for use by the ceres_awx project.

Requirements
------------

This role requires that an Azure resource group has been created for the landing zone artifacts to be created in
and an Azure AD Service Principal account with contrubutor access to the resource group.

Role Variables
--------------

These are defined in [defults/main.yml](defults/main.yml) and [vars/main.yml](vars/main.yml)

Dependencies
------------

The following collections are used by this role:
*  TBD

Example Playbook
----------------

TBD

License
-------

MIT

Author Information
------------------

Written by Richard Gowen (a.k.a. @alt_bier)
