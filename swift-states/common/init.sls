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
