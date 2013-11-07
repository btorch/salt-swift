syslog-ng_pkg:
  pkg:
    - name: syslog-ng
    - installed
    - skip_verify: True

{% if 'admin' not in grains['roles'] %}
syslog-ng_conf:
  file.managed:
    - name: /etc/syslog-ng/syslog-ng.conf
    {% if grains['os_family'] == 'Debian' %}
    - source: salt://common/syslog-ng_v3_3.conf
    {% elif grains['os_family'] == 'Redhat' %}
    - source: salt://common/syslog-ng_v3_2.conf
    {% endif %}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        remote_syslog_ip: 127.0.0.1
    - require:
      - pkg: syslog-ng_pkg
{% elif 'admin' in grains['roles'] %}
syslog-ng_conf:
  file.managed:
    - name: /etc/syslog-ng/syslog-ng.conf
    {% if grains['os_family'] == 'Debian' %}
    - source: salt://admin/syslog-ng_v3_3.conf
    {% elif grains['os_family'] == 'Redhat' %}
    - source: salt://admin/syslog-ng_v3_2.conf
    {% endif %}
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - require:
      - pkg: syslog-ng_pkg
{% endif %}

syslog-ng_svc:
  service:
    - running
    - reload: True
    - enable: True
    - name: syslog-ng
    {% if grains['os_family'] == 'Debian' %}
    - sig: '/usr/sbin/syslog-ng -p /var/run/syslog-ng.pid'
    {% elif grains['os_family'] == 'Redhat' %}
    - sig: 'syslog-ng -p /var/run/syslog-ng.pid'
    {% endif %}
    - require:
      - pkg: syslog-ng_pkg
      - file.managed: syslog-ng_conf
    - watch:
      - file.managed: syslog-ng_conf
