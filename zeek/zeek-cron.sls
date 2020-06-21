# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}

# Make sure cron is installed
{% if salt.grains.get('os_family') == 'RedHat' %}
  {% set cron_package = 'cronie' %}
{% elif salt.grains.get('os_family') == 'Debian' %}
  {% set cron_package = 'cron' %}
{% endif %}
package-install-cron-zeek:
  pkg.installed:
    - pkgs:
      - {{ cron_package }}
    - refresh: True

# Setup Cron for ZEEK runs every 5 minutes
{{ config.zeek.BinDir }}/zeekctl cron:
  cron.present:
    - comment: "Check for Zeek nodes that have crashed and general housekeeping"
    - identifier: "ZEEK_Check"
    - user: root
    - minute: '*/5'
