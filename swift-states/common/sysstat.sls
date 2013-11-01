sysstat:
  pkg:
    - installed
    - skip_verify: True

{% if grains['os_family'] == 'Debian' %}
/etc/default/sysstat:
  file.replace:
    - path: /etc/default/sysstat
    - pattern: 'ENABLED="false"'
    - repl: 'ENABLED="true"'
    - require:
      - pkg: sysstat
{% endif %}

sysstat_init:
  service:
    - running
    - reload: True
    - enable: True
    - name: sysstat
    - require:
      - pkg: sysstat
