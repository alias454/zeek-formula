# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}

# Update the current path with zeek path
/etc/profile.d/zeek_path.sh:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        if [ -d "{{ config.zeek.BinDir }}" ]; then
            PATH={{ config.zeek.BinDir }}:$PATH
        fi

# Create group as a system group 
group-manage-zeek:
  group.present:
    - name: zeek
    - system: True

# Manage the <zeek_base>/share/zeek/site/local.zeek file
{{ config.zeek.ShareDir }}/site/local.zeek:
  file.managed:
    - source: salt://zeek/files/local.site
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'

# Manage the <zeek_base>/etc/zeekctl.cfg
{{ config.zeek.CfgDir }}/zeekctl.cfg:
  file.managed:
    - source: salt://zeek/files/zeekctl.cfg
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'

# Manage the <zeek_base>/etc/node.cfg file
{{ config.zeek.CfgDir }}/node.cfg:
  file.managed:
    - source: salt://zeek/files/node.cfg
    - template: jinja
    - user: root
    - group: zeek
    - mode: '0664'

# Manage the <zeek_base>/etc/networks.cfg file
{{ config.zeek.CfgDir }}/networks.cfg:
  file.managed:
    - user: root
    - group: zeek
    - mode: '0664'
    - contents: |
        # List of local networks in CIDR notation, optionally followed by a
        # descriptive tag.
        # For example, "10.0.0.0/8" or "fe80::/64" are valid prefixes.

        10.0.0.0/8          Private IP space
        172.16.0.0/12       Private IP space
        192.168.0.0/16      Private IP space
        
# Configure network options
{% if config.zeek.interfaces.capture.enable == 'True' %}
network_configure_{{ config.zeek.interfaces.capture.device_names }}:
  network.managed:
    - name: {{ config.zeek.interfaces.capture.device_names }}
    - enabled: True
    - retain_settings: True
    - type: eth
    - proto: none
    - autoneg: on
    - duplex: full
    - rx: off
    - tx: off
    - sg: off
    - tso: off
    - ufo: off
    - gso: off
    - gro: off
    - lro: off
    - watch_in:
      - servcie: service-zeek
{% endif %}

# Manage systemd unit file to control promiscuous mode
/usr/lib/systemd/system/netcfg@.service:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
        [Unit]
        Description=Control promiscuous mode for interface %i
        After=network.target

        [Service]
        Type=oneshot
        ExecStart={{ config.zeek.interfaces.ip_binary_path }} link set %i promisc on
        ExecStop={{ config.zeek.interfaces.ip_binary_path }} link set %i promisc off
        RemainAfterExit=yes

        [Install]
        WantedBy=multi-user.target
        
# Manage systemd unit file to control zeek
# https://gist.github.com/JustinAzoff/db71b901b1070a88f2d72738bf212749
/usr/lib/systemd/system/zeek.service:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - makedirs: true
    - contents: |
        [Unit]
        Description=Zeek
        After=network.target

        [Service]
        ExecStartPre=-{{ config.zeek.BinDir }}/zeekctl cleanup
        ExecStartPre={{ config.zeek.BinDir }}/zeekctl deploy
        ExecStart={{ config.zeek.BinDir }}/zeekctl start
        ExecStop={{ config.zeek.BinDir }}/zeekctl stop
        RestartSec=10s
        Type=oneshot
        RemainAfterExit=yes

        [Install]
        WantedBy=multi-user.target
