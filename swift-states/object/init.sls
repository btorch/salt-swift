/tmp/object-server.conf:
  file.managed:
    - source: salt://object/account-server.conf
    - user: root
    - group: root
    - template: jinja
