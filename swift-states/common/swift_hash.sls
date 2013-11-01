/tmp/swift.conf:
  file.managed:
    - source: salt://common/swift.conf
    - user: root
    - group: root
    - template: jinja
