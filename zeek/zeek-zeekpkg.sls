# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}
{% if config.zeek.use_ZeekPKG == 'True' %}
# zeek-pkg is not bundled with the main install so we install it.

{% if salt.grains.get('os_family') == 'RedHat' %}

# Install prereqs for RHEL based systems
{% if grains['osmajorrelease'] == 7 %}
  {% set python_devel_pkg = 'python3-devel' %}
{% elif grains['osmajorrelease'] == 8 %}
  {% set python_devel_pkg = 'python36-devel' %}
{% endif %}
package-install-prereqs-zeekpkg:
  pkg.installed:
    - pkgs:
       - kernel-headers
       - kernel-devel
       - libpcap-devel
       - openssl-devel
       - {{ python_devel_pkg }}
       - cmake
       - make
       - gcc
       - gcc-c++
    - refresh: True

# Install prereqs for Debian based systems
{% elif salt.grains.get('os_family') == 'Debian' %}

# Set hard value for kernel incase
# running container on a different platform
{% if salt['grains.get']('virtual_subtype') == 'Docker' %}
  {% if salt.grains.get('os') == 'Debian' %}
    {% set kernelrelease = 'amd64' %} #'4.9.0-3-all'
  {% elif salt.grains.get('os') == 'Ubuntu' %}
    {% set kernelrelease = 'virtual' %}
  {% endif %}
{% else %}
  {% set kernelrelease = salt['grains.get']('kernelrelease') %}
{% endif %}

package-install-prereqs-zeekpkg:
  pkg.installed:
    - pkgs:
       - linux-headers-{{ kernelrelease }}
       - libpcap-dev
       - libssl-dev
       - python3-dev
       - cmake
       - make
       - gcc
       - g++
    - refresh: True
{% endif %} # End RedHat/Debian

# Install/upgrade zeek-pkg requirements using pip3
pip-package-pip-zeek:
  pip.installed:
    - names:
       - pip
       - setuptools
    - upgrade: True
    - bin_env: {{ config.zeek.python_pip_cmd }}
    - user: root
    - reload_modules: True
    - require:
      - pkg: package-install-prereqs-zeekpkg

# Install the zkg module
pip-package-install-zeek-pkg:
  pip.installed:
    - names:
       - zkg
    - upgrade: True
    - bin_env: {{ config.zeek.python_pip_cmd }}
    - user: root
    - reload_modules: True
    - require:
      - pip: pip-package-pip-zeek

# Run autoconfig
zeek-pkg-autoconfig:
  cmd.run:
    - name: zkg autoconfig
    - creates: /root/.zkg/config # either .zkg or .zeek-pkg
    - unless: echo $(which zkg) |grep "no zkg"
    - runas: root
    - require:
      - pip: pip-package-install-zeek-pkg

# Install plugins using zkg
{% if config.package.install_type != 'package' %}
{% for pkg in config.zeek.addon_plugins %}
zeek-pkg-install-{{ pkg.plugin }}:
  cmd.run:
    - name: zkg install {{ pkg.plugin }} --force
    - unless: zkg list installed |grep {{ pkg.plugin }}
    - runas: root
    - require:
      - pip: pip-package-install-zeek-pkg
      - cmd: zeek-pkg-autoconfig
{% endfor %}
{% endif %}
{% endif %}
