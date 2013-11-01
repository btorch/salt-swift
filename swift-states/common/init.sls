include:
  - common.openstack_repo
  - common.sysstat

common_pkgs:
  pkg:
    - installed
    - order: 1
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
      - gcc
      - parted
      - python-pip
      - python-setuptools
      {% if grains['os_family'] == 'Debian' %}
      - debconf
      - nmon
      - sqlite3
      - bsd-mailx
      - ubuntu-cloud-keyring
      {% elif grains['os_family'] == 'Redhat' %}
      - iptraf-ng
      - mailx
      {% endif %}
