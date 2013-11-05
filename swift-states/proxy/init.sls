include:
  - common.openstack_repo
  - proxy.memcached

swift-proxy:
  pkg.installed:
    - skip_verify: True
    {% if grains['os_family'] == 'Debian' %}
    - name: swift-proxy
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-proxy
    {% endif %}
    - require:
      {% if grains['os_family'] == 'Debian' %}
      - pkgrepo: ubuntu_cloud_repo
      {% elif grains['os_family'] == 'Redhat' %}
      - pkgrepo: epel_repo
      - pkgrepo: epel_openstack_repo
      {% endif %}
      - pkg: memcached
  service:
    - running
    {% if grains['os_family'] == 'Debian' %}
    - name: swift-proxy
    {% elif grains['os_family'] == 'Redhat' %}
    - name: openstack-swift-proxy
    {% endif %}
    - sig: swift-proxy-server
    - enable: True
    - reload: True
    - require:
      - pkg: swift-proxy
      - file: /etc/swift/proxy-server.conf
    - watch:
      - file: /etc/swift/proxy-server.conf

/etc/swift/proxy-server.conf:
  file.managed:
    - source: salt://proxy/proxy-server.conf
    - user: swift
    - group: swift
    - template: jinja
