/etc/swift/account-server.conf:
  file.managed:
    - source: salt://account/account-server.conf
    - user: swift
    - group: swift
    - template: jinja
