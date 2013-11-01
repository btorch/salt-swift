/tmp/proxy-server.conf:
  file.managed:
    - source: salt://proxy/proxy-server.conf
    - user: root
    - group: root
    - template: jinja
