# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}
{% if config.zeek.logging.use_rsyslog == 'True' %}

# Configure rsyslog settings for sending zeek logs to a remote log collector
zeek_rsyslog_config:
  file.managed:
    - name: /etc/rsyslog.d/00-zeek.conf
    - source: salt://zeek/files/rsyslog_00-zeek.conf
    - template: jinja
    - user: root
    - group: root
    - mode: '0644'

{% if salt.grains.get('os_family') == 'RedHat' %}
command-semanage-{{ config.zeek.logging.protocol }}-{{ config.zeek.logging.port }}-rsyslog-port:
  cmd.run:
    - name: semanage port -a -t syslogd_port_t -p {{ config.zeek.logging.protocol }} {{ config.zeek.logging.port }}
    - unless: semanage port -l |grep syslog |grep {{ config.zeek.logging.port }}
    - require-in:
      - service: service-rsyslog-zeek
    - require:
      - pkg: package-install-zeek
{% endif %}

# Make sure rsyslog is running if use_rsyslog is true
service-rsyslog-zeek:
  service.running:
    - name: rsyslog
    - enable: True
    - watch:
      - file: zeek_rsyslog_config
{% endif %}
