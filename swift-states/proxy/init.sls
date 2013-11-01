/etc/swift/proxy-server.conf:
  file.managed:
    - source: salt://proxy/proxy-server.conf
    - user: swift
    - group: swift
    - template: jinja
