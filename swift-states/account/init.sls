/tmp/account-server.conf:
  file.managed:
    - source: salt://account-server/account-server.conf
    - user: root
    - group: root
    - template: jinja
