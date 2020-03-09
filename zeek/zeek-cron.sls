# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}

# Make sure cronie is installed
{% if salt.grains.get('os_family') == 'RedHat' %}
package-install-cronie-zeek:
  pkg.installed:
    - pkgs:
      - cronie
    - refresh: True
{% elif salt.grains.get('os_family') == 'Debian' %}
{% endif %}

# Setup Cron for ZEEK runs every 5 minutes
{{ config.zeek.BinDir }}/zeekctl cron:
  cron.present:
    - comment: "Check for Zeek nodes that have crashed and general housekeeping"
    - identifier: "ZEEK_Check"
    - user: root
    - minute: '*/5'
