/tmp/object-server.conf:
  file.managed:
    - source: salt://object/object-server.conf
    - user: root
    - group: root
    - template: jinja
