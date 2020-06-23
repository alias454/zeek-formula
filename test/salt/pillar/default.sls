# -*- coding: utf-8 -*-
# vim: ft=yaml
---
# ZEEK docs https://www.zeek.org/documentation/index.html
zeek:
  lookup:
    package:
    {% if grains['os_family'] == 'RedHat' %}
      install_type: 'package'                      # Install type can be package or local (support for tarball not implemented)
      local_package:                               # Can be multiple packages like zeek, zeekctl, zeekccoli etc.
        - pack_id: 'zeek-full'
          package: 'zeek-lts-3.0.7-1.2.x86_64'     # Custom package to be deployed
          name: 'zeek'                             # Name of installed package
          type: 'rpm'                              # Type should be deb or rpm based on platform
      use_repo: 'True'                             # Zeek can be installed from epel or a local rpm not just zeek repos
     {% if grains['osmajorrelease'] == 7 %}
      package:
        - zeek-lts
        - zeekctl-lts
      repo_baseurl: 'https://download.opensuse.org/repositories/security:/zeek/CentOS_7/'
      repo_gpgkey: 'https://download.opensuse.org/repositories/security:/zeek/CentOS_7/repodata/repomd.xml.key'
     {% elif grains['osmajorrelease'] == 8 %}
      package:
        - zeek
        - zeekctl
      repo_baseurl: 'https://download.opensuse.org/repositories/security:/zeek/CentOS_8/'
      repo_gpgkey: 'https://download.opensuse.org/repositories/security:/zeek/CentOS_8/repodata/repomd.xml.key'
     {% endif %}
      skip_verify: '0'
    {% elif grains['os_family'] == 'Debian' %}
      install_type: 'package'                      # Install type can be package (support for tarball or local not implemented)
      use_repo: 'True'                             # Debian 9 does not require an external repo
     {% if grains['osmajorrelease'] == 9 %}
      package:
        - zeek-lts
        - zeekctl-lts
      repo_baseurl: 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_9.0/ /'
      repo_gpgkey: 'https://download.opensuse.org/repositories/security:zeek/Debian_9.0/Release.key'
     {% elif grains['osmajorrelease'] == 10 %}
      package:
        - zeek
        - zeekctl
      repo_baseurl: 'deb http://download.opensuse.org/repositories/security:/zeek/Debian_10/ /'
      repo_gpgkey: 'https://download.opensuse.org/repositories/security:zeek/Debian_10/Release.key'
     {% elif grains['osfinger'] == 'Ubuntu-18.04' %} #Ubuntu 18.04
      package:
        - zeek
        - zeekctl
      repo_baseurl: 'deb http://download.opensuse.org/repositories/security:/zeek/xUbuntu_18.04/ /'
      repo_gpgkey: 'https://download.opensuse.org/repositories/security:zeek/xUbuntu_18.04/Release.key'
     {% endif %}
      skip_verify: '0'
    {% endif %}
    zeek:
      use_ZeekPKG: 'True'                    # Use zeek-pkg to manage plugins (requird for plugins such as af_packet etc)
      python_pip_cmd: '/usr/bin/pip3'        # Use pip3 to install zeekPKG
      addon_plugins:                         # List of plugins to install if zeek-pkg is enabled
        - plugin: 'zeek-af_packet-plugin'    # af_packet is required when use_afpacket == True
      MailTo: 'root@localhost'               # Recipient address for all emails sent out by Zeek and ZeekControl
      SendMail: '/sbin/sendmail'             # Path to sendmail binary
      MailConnectionSummary: '1'             # Send mail connection summaries
      MinDiskSpace: '5'                      # Threshold (in percentage of disk space) for HDD where SpoolDir lives
      MailHostUpDown: '1'                    # Send mail when "zeekctl cron" notices a host in the cluster has changed
      LogRotationInterval: '3600'            # Log rotation interval in seconds for current logs
      LogExpireInterval: '0'                 # Files older than this will be deleted by "zeekctl cron" 0 is never
      StatsLogEnable: '1'                    # Enable ZeekControl to write statistics to the stats.log file
      StatsLogExpireInterval: '0'            # Number of days that entries in the stats.log file are kept
      StatusCmdShowAll: '0'                  # Show all output of the zeekctl status command
      CrashExpireInterval: '0'               # Number of days that crash directories are kept
      SitePolicyScripts: 'local.zeek'        # Site-specific policy script to load
      base_dir: '/opt/zeek'                  # /opt/zeek is default for yum package install
      mode: 'standalone'                     # Mode can be standalone or lb_cluster (load balanced cluster)
      use_pfring: 'False'                    # If pf_ring is installed set this to True. Must use "pf_ring" lb_method
      use_afpacket: 'True'                   # If you use AF_PACKET set this to True. Must use "custom" lb_method and use_ZeekPKG set to True
      lb_method: 'custom'                    # Load balancer type ("pf_ring" or "custom" are supported)
      lb_procs: '2'                          # Number of processors to run ZEEK workers with
      logging:
        use_rsyslog: 'False'                 # Enable rsyslog usage
      bpf:
        use_BPFconf: 'True'                  # Use Berkeley Packet Filter(BPF) on capture interfaces
        bpf_rules: []                        # Add custom BPF rules
      optional:
        use_LibgeoIP: 'False'                # Use LibgeoIP(less useful if sending logs upstream)
        use_sendmail: 'False'                # Use sendmail(needs sendmail/postfix to be installed)
        relayhost: 'mail.domain.tld'         # Send email to a relay host
      interfaces:
        ip_binary_path: '/sbin/ip'           # path to ip binary for managing
        management: 'eth0'                   # Management interface name
        capture:
          enable: 'False'
          device_names: 'eth0'               # Capture interface name (currently only supports 1 interface)
          enable_tx: '0'                     # Enable tx send on this interface (default is 0)
          min_num_slots: '4096'              # Min Slots check support on card using ethtool -g eth1
