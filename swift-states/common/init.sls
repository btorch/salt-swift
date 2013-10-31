common_pkgs:
  pkg:
    - installed
    - skip_verify: True
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
      - strace
      - iotop
      - screen 

distro_diff_pkgs:
  pkg:
    - installed
    - skip_verify: True
    {% if grains['os_family'] == 'Debian' %}
    - pkgs:
      - debconf
      - nmon
      - sqlite3
      - bsd-mailx
    {% elif grains['os_family'] == 'Redhat' %}
    - pkgs:
      - iptraf-ng
      - mailx
    {% endif %}

sysstat:
  pkg:
    - installed
    - skip_verify: True

{% if grains['os_family'] == 'Debian' %}
/etc/default/sysstat:
  file
    - replace
    - path: /etc/default/sysstat
    - pattern: 'ENABLED="false"'
    - repl: 'ENABLED="true"'
    - require:
      - pkg: common_pkgs
{% endif %}

sysstat_init:
  service:
    - running
    - reload: True
    - enable: True
    - name: sysstat
    - require:
      - pkg: sysstat

