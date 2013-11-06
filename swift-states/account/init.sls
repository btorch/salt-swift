include:
  - common.openstack_repo
  - common.rsync
  - common.drive_audit

swift-account-pkg:
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
      - pkg: rsync_pkg

/etc/swift/account-server.conf:
  file.managed:
    - source: salt://account/account-server.conf
    - user: swift
    - group: swift
    - template: jinja

{% set account_svcs = ['swift-account', 'swift-account-auditor', 'swift-account-reaper'] %}
{% for svc_name in account_svcs %}
{{ svc_name }}:
  service.running:
    - name: {{ svc_name }}
    {% if svc_name == 'swift-account' %}
    - sig: swift-account-server
    {% else %}
    - sig: {{ svc_name }}
    {% endif %}
    - reload: True
    - require:
      - pkg: swift-account-pkg
      - file: /etc/swift/account-server.conf
    - watch:
      - file: /etc/swift/account-server.conf
{% endfor %}

{# The swift-account-replicator is apart since it needs to ring to startup #}
{# unfortunately there is no break/continue on jinja For Loops #}
{% if salt['file.file_exists']('/etc/swift/account.ring.gz') %}
swift-account-replicator:
  service.running:
    - name: swift-account-replicator
    - sig: swift-account-replicator
    - reload: True
    - require:
      - pkg: swift-account-pkg
      - file: /etc/swift/account-server.conf
    - watch:
      - file: /etc/swift/account-server.conf
{% endif %}
