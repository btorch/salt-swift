include:
  - common.openstack_repo
  - common.rsync

swift-object-pkg:
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
      - pkg: rsync_pkg

/etc/swift/object-server.conf:
  file.managed:
    - source: salt://object/object-server.conf
    - user: swift
    - group: swift
    - template: jinja

{% set object_svcs = ['swift-object', 'swift-object-auditor', 'swift-object-updater'] %}
{% for svc_name in object_svcs %}
{{ svc_name }}:
  service.running:
    - name: {{ svc_name }}
    {% if svc_name == 'swift-object' %}
    - sig: swift-object-server
    {% else %}
    - sig: {{ svc_name }}
    {% endif %}
    - reload: True
    - require:
      - pkg: swift-object-pkg
      - file: /etc/swift/object-server.conf
    - watch:
      - file: /etc/swift/object-server.conf
{% endfor %}

{# The swift-object-replicator is apart since it needs to ring to startup #}
{# unfortunately there is no break/continue on jinja For Loops #}
{% if salt['file.file_exists']('/etc/swift/object.ring.gz') %}
swift-object-replicator:
  service.running:
    - name: swift-object-replicator
    - sig: swift-object-replicator
    - reload: True
    - require:
      - pkg: swift-object-pkg
      - file: /etc/swift/object-server.conf
    - watch:
      - file: /etc/swift/object-server.conf
{% endif %}
