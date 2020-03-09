# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}
{% if config.zeek.use_ZeekPKG == 'True' %}
# zeek-pkg is not bundled with the main install so we install it.

{% if salt.grains.get('os_family') == 'RedHat' %}
# Install prereqs for RHEL based systems
package-install-prereqs-zeekpkg:
  pkg.installed:
    - pkgs:
       - kernel-headers
       - kernel-devel
       - libpcap-devel
       - openssl-devel
       - python-devel
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
       - python-dev
       - cmake
       - make
       - gcc
       - g++
    - refresh: True
{% endif %} # End RedHat/Debian

# Install pip and other required packages
pip-install-zeek:
  pkg.installed:
    - pkgs:
      - {{ config.zeek.python_pip_pkg }}
    - refresh: True
    - unless: echo $(which zeek-pkg) |grep "no zeek-pkg"
    - require:
      - pkg: package-install-prereqs-zeekpkg
      - pkg: package-install-zeek

# Upgrade older versions of pip
pip-upgrade-zeek:
  cmd.run:
    - name: {{ config.zeek.python_pip_cmd }} install --upgrade pip
    - onlyif: {{ config.zeek.python_pip_cmd }} list --outdated |grep pip
    - runas: root
    - require:
      - pkg: pip-install-zeek

# Install the zeek-pkg module
pip-package-install-zeek-pkg:
  cmd.run:
    - name: {{ config.zeek.python_pip_cmd }} install --upgrade zeek-pkg
    #- onlyif: {{ config.zeek.python_pip_cmd }} list --outdated |grep zeek-pkg
    - unless: echo $(which zeek-pkg) |grep "no zeek-pkg"
    - runas: root
    - require:
      - cmd: pip-upgrade-zeek

# Run autoconfig
zeek-pkg-autoconfig:
  cmd.run:
    - name: zeek-pkg autoconfig
    - creates: /root/.zeek-pkg/config # either .zkg or .zeek-pkg
    - unless: echo $(which zeek-pkg) |grep "no zeek-pkg"
    - runas: root
    - require:
      - cmd: pip-package-install-zeek-pkg 

# Install plugins using zeek-pkg
{% if config.package.install_type != 'package' %}
{% for pkg in config.zeek.addon_plugins %}
zeek-pkg-install-{{ pkg.plugin }}:
  cmd.run:
    - name: zeek-pkg install {{ pkg.plugin }} --force
    - unless: zeek-pkg list installed |grep {{ pkg.plugin }}
    - runas: root
    - require:
      - cmd: pip-package-install-zeek-pkg 
      - cmd: zeek-pkg-autoconfig
{% endfor %}
{% endif %}
{% endif %}
