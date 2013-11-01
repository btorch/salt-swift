/etc/swift/container-server.conf:
  file.managed:
    - source: salt://container/container-server.conf
    - user: swift
    - group: swift
    - template: jinja
