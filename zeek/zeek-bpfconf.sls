# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}
{% if config.zeek.bpf.use_BPFconf == 'True' %}

# Manage the <zeek_base>/etc/bpf-zeek.conf file
{{ config.zeek.CfgDir }}/bpf-zeek.conf:
  file.managed:
    - source: salt://zeek/files/bpf-zeek.conf
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - watch_in:
      - service: service-zeek

# Manage the <base_dir>/share/zeek/bpfconf/__load__.zeek file
{{ config.zeek.ShareDir }}/bpfconf/__load__.zeek:
  file.managed:
    - source: salt://zeek/files/bpfconf/__load__.zeek
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-zeek

# Manage the <zeek_base>/share/zeek/bpfconf/bpfconf.zeek file
{{ config.zeek.ShareDir }}/bpfconf/bpfconf.zeek:
  file.managed:
    - source: salt://zeek/files/bpfconf/bpfconf.zeek
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-zeek

# Manage the <zeek_base>/share/zeek/bpfconf/interface.zeek file
{{ config.zeek.ShareDir }}/bpfconf/interface.zeek:
  file.managed:
    - source: salt://zeek/files/bpfconf/interface.zeek
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-zeek

# Manage the <zeek_base>/share/zeek/bpfconf/readfile.zeek file
{{ config.zeek.ShareDir }}/bpfconf/readfile.zeek:
  file.managed:
    - source: salt://zeek/files/bpfconf/readfile.zeek
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-zeek

# Manage the <zeek_base>/share/zeek/bpfconf/sensorname.zeek file
{{ config.zeek.ShareDir }}/bpfconf/sensorname.zeek:
  file.managed:
    - source: salt://zeek/files/bpfconf/sensorname.zeek
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-zeek

# Manage the <zeek_base>/share/zeek/bpfconf/sensortab.zeek file
{{ config.zeek.ShareDir }}/bpfconf/sensortab.zeek:
  file.managed:
    - source: salt://zeek/files/bpfconf/sensortab.zeek
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'
    - makedirs: true
    - watch_in:
      - service: service-zeek
{% endif %}
