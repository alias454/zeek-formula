# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}

# Prior to enabling the service reload systemctl
systemd-reload-zeek:
  cmd.run:
    - name: systemctl --system daemon-reload
    - onchanges:
      - file: /usr/lib/systemd/system/zeek.service

# Make sure zeek service is running and restart the service 
service-zeek:
  service.running:
    - name: zeek
    - enable: True
    - watch:
      - file: {{ config.zeek.CfgDir }}/zeekctl.cfg
      - file: {{ config.zeek.CfgDir }}/node.cfg
      - file: {{ config.zeek.CfgDir }}/networks.cfg
      - file: /usr/lib/systemd/system/zeek.service
    - require:
      - cmd: systemd-reload-zeek

# Make sure netcfg@ service is running and enabled
{% if config.zeek.interfaces.capture.enable == 'True' %}
service-netcfg@{{ config.zeek.interfaces.capture.device_names }}:
  service.running:
    - name: netcfg@{{ config.zeek.interfaces.capture.device_names }}
    - enable: True
    - require:
      - file: /usr/lib/systemd/system/netcfg@.service
      - network: network_configure_{{ config.zeek.interfaces.capture.device_names }}
{% endif %}
