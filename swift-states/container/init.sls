include:
  - common.openstack_repo

swift-container:
  pkg.installed:
    - skip_verify: True
    {% if grains['os_family'] == 'Debian' %}
    - name: swift-container
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-container
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
    {% if grains['os_family'] == 'Debian' %}
    - name: swift-container
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-container
    {% endif %}
    - sig: swift-container-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-container
      - file: /etc/swift/container-server.conf
    - watch:
      - file: /etc/swift/container-server.conf

/etc/swift/container-server.conf:
  file.managed:
    - source: salt://container/container-server.conf
    - user: swift
    - group: swift
    - template: jinja
