memcached:
  pkg.installed:
    - skip_verify: True
    - pkgs:
      - memcached
    {% if grains['os_family'] == 'Debian' %}
      - python-memcached
    {% elif grains['os_family'] == 'Redhat' %}
      - python-memcache
    {% endif %}
  file.managed:
    - name: /etc/memcached.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        logfile: {{ pillar['memcached']['logfile'] }}
        memory: {{ pillar['memcached']['memory'] }}
        user: {{ pillar['memcached']['user'] }}
        connections: {{ pillar['memcached']['connections'] }}
  service:
    - running
    - enable: True
    - reload: True
    - require:
      - pkg: memcached
      - file: /etc/memcached.conf
    - watch:
      - file: /etc/memcached.conf
