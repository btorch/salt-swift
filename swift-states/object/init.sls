/etc/swift/object-server.conf:
  file.managed:
    - source: salt://object/object-server.conf
    - user: swift
    - group: swift
    - template: jinja
