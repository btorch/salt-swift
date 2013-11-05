rsync_pkg:
  pkg:
    - name: rsync
    - installed
    - skip_verify: True

{% if grains['os_family'] == 'Debian' %}
rsync_default:
  file.replace:
    - path: /etc/default/rsync
    - pattern: 'RSYNC_ENABLE=false'
    - repl: 'RSYNC_ENABLE=true'
    - require:
      - pkg: rsync_pkg
{% endif %}

rsyncd_conf:
  file.managed:
    - name: /etc/rsyncd.conf
    - source: salt://common/storage/rsyncd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        account_conns: 4
        container_conns: 6
        object_conns: 8
    - require:
      - pkg: rsync_pkg

rsync_svc:
  service:
    - running
    - reload: True
    - enable: True
    {% if grains['os_family'] == 'Debian' %}
    - name: rsync
    - sig: '/usr/bin/rsync --no-detach --daemon'
    {% elif grains['os_family'] == 'Redhat' %}
    - name: rsyncd
    - sig: '/usr/bin/rsync --daemon'
    {% endif %}
    - require:
      - pkg: rsync_pkg
      - file.replace: rsync_default
      - file.managed: rsyncd_conf
