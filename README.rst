zeek-formula
============

|img_travis|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/zeek-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%

A saltstack formula to install Zeek(BRO) Network Security Monitor on RHEL or Debian based systems.

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list

.. contents:: **Table of Contents**
      :depth: 1

Optional
--------

Formulas exist to help with installation and management of
other components such as pf_ring.

pfring-formula  
https://github.com/saltstack-formulas/pfring-formula

Compile your own zeek package using the guide `RPM package creation for ZEEK IDS Deployments https://alias454.com/rpm-package-creation-for-bro-ids-deployments/`_.

General notes
-------------

.. note::

    The **FORMULA** file, contains informtion about the version of this formula, tested OS and OS families, and the minimum tested version of salt.

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

Available states
----------------

.. contents::
    :local:

``zeek``
^^^^^^^
*Meta-state (This is a state that includes other states)*.

Installs **zeek** and it's requirements, manages the configuration file, and starts the service.

``zeek.zeek-repo``
^^^^^^^^^^^^^^^^^^
Manage repo files on RHEL/CentOS 7 or Debian systems.  
RHEL/CentOS 8 requires creating a custom package due to lack of supported packages

``zeek.zeek-prereqs``
^^^^^^^^^^^^^^^^^^^^^
Install prerequisite packages.

``zeek.zeek-package``
^^^^^^^^^^^^^^^^^^^^^
Install zeek packages.

``zeek.zeek-config``
^^^^^^^^^^^^^^^^^^^^
Manage configuration file placement.

``zeek.zeek-bpfconf``
^^^^^^^^^^^^^^^^^^^^^
Manage BPF module and configuration.  
Supports a single zeek-bpf.conf file that applies to all capture interfaces.

``zeek.zeek-sendmail``
^^^^^^^^^^^^^^^^^^^^^^
If using sendmail(postfix), manage relay host and service.

``zeek.zeek-service``
^^^^^^^^^^^^^^^^^^^^^
Manage zeek service and a service to manage promiscuous mode of defined network interfaces on RHEL/CentOS 7/Debian systems.

``zeek.zeek-syslog``
^^^^^^^^^^^^^^^^^^^^
Manage rsyslog config and service to send specifc log types to a remote collector.

``zeek.zeek-zeekpkg``
^^^^^^^^^^^^^^^^^^^^^
Manage zeek-pkg pip module and plugin installations.

``zeek.zeek-cron``
^^^^^^^^^^^^^^^^^^
Manage zeekctl cron entry.

Testing
-------

Linux testing is done with **kitchen-salt**.

Requirements
^^^^^^^^^^^^

* Ruby
* Docker

.. code-block:: bash

   $ gem install bundler
   $ bundle install
   $ bin/kitchen test [platform]

Where **[platform]** is the platform name defined in **kitchen.yml**,  
e.g. **debian-9-2019-2-py3**.

Test options
^^^^^^^^^^^^

``bin/kitchen converge``
^^^^^^^^^^^^^^^^^^^^^^^^
Creates the docker instance and runs the **zeek** main state, ready for testing.

``bin/kitchen verify``
^^^^^^^^^^^^^^^^^^^^^^
Runs the **inspec** tests on the actual instance.

``bin/kitchen destroy``
^^^^^^^^^^^^^^^^^^^^^^^
Removes the docker instance.

``bin/kitchen test``
^^^^^^^^^^^^^^^^^^^^
Runs all of the stages above in one go: i.e. **destroy** + **converge** + **verify** + **destroy**.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^
Gives you SSH access to the instance for manual testing if automated testing fails.
