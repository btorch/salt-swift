/tmp/container-server.conf:
  file.managed:
    - source: salt://container/container-server.conf
    - user: root
    - group: root
    - template: jinja
