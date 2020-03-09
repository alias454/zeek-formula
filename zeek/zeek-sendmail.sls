# -*- coding: utf-8 -*-
# vim: ft=sls

{% from "zeek/map.jinja" import host_lookup as config with context %}
{% if config.zeek.optional.use_sendmail == 'True' %}

# Configure sendmail settings(defaults to using postfix sendmail)
zeek_sendmail_config:
  file.replace:
    - name: /etc/postfix/main.cf
    - pattern: |
        #relayhost = \$mydomain
        .?relayhost = \[[a-zA-Z0-9.-:/]+\]
    - repl: |
        #relayhost = $mydomain
        relayhost = [{{ config.zeek.optional.relayhost }}]

# Make sure postfix is running if use_sendmail is true
service-postfix-zeek:
  service.running:
    - name: postfix
    - enable: True
    - watch:
      - file: zeek_sendmail_config
{% endif %}
