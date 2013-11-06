include:
  - common.openstack_repo
  - common.rsync

swift-container-pkg:
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
      - pkg: rsync_pkg

/etc/swift/container-server.conf:
  file.managed:
    - source: salt://container/container-server.conf
    - user: swift
    - group: swift
    - template: jinja

{% set container_svcs = ['swift-container', 'swift-container-auditor', 'swift-container-updater'] %}
{% for svc_name in container_svcs %}
{{ svc_name }}:
  service.running:
    - name: {{ svc_name }}
    {% if svc_name == 'swift-container' %}
    - sig: swift-container-server
    - reload: True
    {% else %}
    - sig: {{ svc_name }}
    - full_restart: True
    {% endif %}
    - require:
      - pkg: swift-container-pkg
      - file: /etc/swift/container-server.conf
    - watch:
      - file: /etc/swift/container-server.conf
{% endfor %}

{# The swift-container-replicator is apart since it needs to ring to startup #}
{# unfortunately there is no break/continue on jinja For Loops #}
{% if salt['file.file_exists']('/etc/swift/container.ring.gz') %}
swift-container-replicator:
  service.running:
    - name: swift-container-replicator
    - sig: swift-container-replicator
    - full_restart: True
    - require:
      - pkg: swift-container-pkg
      - file: /etc/swift/container-server.conf
    - watch:
      - file: /etc/swift/container-server.conf
{% endif %}
