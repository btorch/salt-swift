include:
  - common.openstack_repo

swift-account:
  pkg.installed:
    - skip_verify: True
    {% if grains['os_family'] == 'Debian' %}
    - name: swift-account
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-account
    {% endif %}
    - require:
      {% if grains['os_family'] == 'Debian' %}
      - pkgrepo: ubuntu_cloud_repo
      {% elif grains['os_family'] == 'Redhat' %}
      - pkgrepo: epel_repo
      - pkgrepo: epel_openstack_repo
      {% endif %}
  service:
    - running
    - name: swift-account-server
    - sig: swift-account-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-account
      - file: /etc/swift/account-server.conf
    - watch:
      - file: /etc/swift/account-server.conf

/etc/swift/account-server.conf:
  file.managed:
    - source: salt://account/account-server.conf
    - user: swift
    - group: swift
    - template: jinja
