include:
  - common.openstack_repo

swift-object:
  pkg.installed:
    - skip_verify: True
    {% if grains['os_family'] == 'Debian' %}
    - name: swift-object
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-object
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
    - name: swift-object
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-object
    {% endif %}
    - sig: swift-object-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-object
      - file: /etc/swift/object-server.conf
    - watch:
      - file: /etc/swift/object-server.conf

/etc/swift/object-server.conf:
  file.managed:
    - source: salt://object/object-server.conf
    - user: swift
    - group: swift
    - template: jinja
