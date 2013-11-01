/tmp/container-server.conf:
  file.managed:
    - source: salt://container/account-server.conf
    - user: root
    - group: root
    - template: jinja
