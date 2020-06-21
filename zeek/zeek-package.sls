# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}
{% if config.package.install_type == 'package' %}

# Install zeek from a package
package-install-zeek:
  pkg.installed:
    - pkgs:
    {% for package in config.package.package %}
      - {{ package }}
    {% endfor %}
    - refresh: True
    - skip_verify: {{ config.package.skip_verify }}
    - require_in:
      - service: service-zeek

{% elif config.package.install_type == 'local' %}

# Install zeek from a local package
package-install-zeek:
  pkg.installed:
    - sources:
    {% for package in config.package.local_package %}
      - {{ package.name }}: salt://zeek/files/{{ package.package }}.{{ package.type }}
    {% endfor %}
    - refresh: True
    - skip_verify: {{ config.package.skip_verify }}
    - require_in:
      - service: service-zeek

{% endif %}

# Make sure correct library paths are configured 
# in case the installer fails to create them
/etc/ld.so.conf.d/zeek-x86_64.conf:
  file.managed:
    - user: root
    - group: root
    - mode: '0644'
    - contents: |
        /opt/zeek/lib
        /opt/zeek/lib64
    - watch_in:
      - service: service-zeek

# Run ldconfig after file is updated
ldconfig-zeek:
  cmd.run:
    - name: ldconfig
    - onchanges:
      - file: /etc/ld.so.conf.d/zeek-x86_64.conf
