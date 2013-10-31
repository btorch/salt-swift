common_pkgs:
  pkg:
    - installed
    - skip_verify: True
    {% if grains['os_family'] == 'Debian' %}
    - pkgs:
      - ntp
      - ntpdate
      - patch
      - debconf
      - dstat
      - ethtool
      - curl
      - iptraf
      - htop
      - nmon
      - sysstat
      - strace
      - iotop
      - debsums
      - screen 
      - sqlite3
    {% endif %}

/etc/default/sysstat:
  file.replace:
    - path: /etc/default/sysstat
    - pattern: 'ENABLED="false"'
    - repl: 'ENABLED="true"'

sysstat_init:
  service:
    - running
    - reload: True
    - name: sysstat
