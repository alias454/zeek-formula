.. _readme:

zeek-formula
============

|img_travis| |img_sr|

.. |img_travis| image:: https://travis-ci.com/saltstack-formulas/zeek-formula.svg?branch=master
   :alt: Travis CI Build Status
   :scale: 100%
   :target: https://travis-ci.com/saltstack-formulas/zeek-formula
.. |img_sr| image:: https://img.shields.io/badge/%20%20%F0%9F%93%A6%F0%9F%9A%80-semantic--release-e10079.svg
   :alt: Semantic Release
   :scale: 100%
   :target: https://github.com/semantic-release/semantic-release

A saltstack formula to install the Zeek Network Security Monitor on RHEL or Debian based systems.  

Supports one capture interface at the moment. Adding ability to control multiple capture interfaces is on the TODO list

.. contents:: **Table of Contents**
      :depth: 1

Optional
--------

Formulas exist to help with installation and management of
other components such as pf_ring.

pfring-formula  
https://github.com/saltstack-formulas/pfring-formula

Compile a custom Zeek package using the guide `RPM package creation for ZEEK IDS Deployments https://alias454.com/rpm-package-creation-for-bro-ids-deployments/`_.

General notes
-------------

See the full `SaltStack Formulas installation and usage instructions
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`_.

If you are interested in writing or contributing to formulas, please pay attention to the `Writing Formula Section
<https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#writing-formulas>`_.

If you want to use this formula, please pay attention to the ``FORMULA`` file and/or ``git tag``,
which contains the currently released version. This formula is versioned according to `Semantic Versioning <http://semver.org/>`_.

See `Formula Versioning Section <https://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html#versioning>`_ for more details.

If you need (non-default) configuration, please pay attention to the ``pillar.example`` file and/or `Special notes`_ section.

Contributing
------------

**Commit message formatting is significant!!**

Please see `How to contribute <https://github.com/saltstack-formulas/.github/blob/master/CONTRIBUTING.rst>`_ for more details.

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
Manage repo files for RHEL or Debian based systems.

``zeek.zeek-prereqs``
^^^^^^^^^^^^^^^^^^^^^
Install prerequisite packages.

``zeek.zeek-package``
^^^^^^^^^^^^^^^^^^^^^
Install zeek packages. This formula can support deploying a custom binary built to your own specs.

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
Manage zeek service and supprt configuring a service to manage promiscuous mode of defined network interfaces on RHEL/Debian systems.

``zeek.zeek-syslog``
^^^^^^^^^^^^^^^^^^^^
Manage rsyslog config and service to send logs to a remote collector.

``zeek.zeek-zeekpkg``
^^^^^^^^^^^^^^^^^^^^^
Manage zkg pip module and plugin installations.

``zeek.zeek-cron``
^^^^^^^^^^^^^^^^^^
Manage zeekctl cron entry for housekeeping tasks.

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

Where ``[platform]`` is the platform name defined in ``kitchen.yml``,  
e.g. ``debian-9-2019-2-py3``.

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
Runs all of the stages above in one go: i.e. ``destroy`` + ``converge`` + ``verify`` + ``destroy``.

``bin/kitchen login``
^^^^^^^^^^^^^^^^^^^^^
Gives you SSH access to the instance for manual testing if automated testing fails.
