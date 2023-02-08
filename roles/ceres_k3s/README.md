ceres_k3s
=========

This role will install k3s lightweight kubernetes.

This is a bare bones role for installing k3s for use with AWX for the ceres_awx project.

Requirements
------------

This role has been designed for use with CentOS Stream 9 and RHEL 9 vms.

Role Variables
--------------

These are defined in [defults/main.yml](defults/main.yml) and [vars/main.yml](vars/main.yml)

Dependencies
------------

The following collections may be needed:
*  community.general
*  ansible.posix
*  containers.podman
*  kubernetes.core

Example Playbook
----------------

TBD

License
-------

MIT

Author Information
------------------

Written by Richard Gowen (a.k.a. @alt_bier)
