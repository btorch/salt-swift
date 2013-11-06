syslog-ng_pkg:
  pkg:
    - name: syslog-ng
    - installed
    - skip_verify: True

syslog-ng_conf:
  file.managed:
    - name: /etc/syslog-ng/syslog-ng.conf
    - source: salt://common/syslog-ng.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        syslog_ver: 3.2
        remote_syslog_ip: 127.0.0.1
    - require:
      - pkg: syslog-ng_pkg

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
