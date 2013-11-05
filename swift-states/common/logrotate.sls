logrotate_pkg:
  pkg:
    - name: logrotate
    - installed
    - skip_verify: True

logrotate_swift:
  file.managed:
    - name: /etc/logrotate.d/logrotate-swift
    - source: salt://common/logrotate-swift
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
    {% if grains['os_family'] == 'Debian' %}
        service_path: /usr/sbin/service
    {% elif grains['os_family'] == 'Redhat' %}
        service_path: /sbin/service
    {% endif %}
    - require:
      - pkg: logrotate_pkg
