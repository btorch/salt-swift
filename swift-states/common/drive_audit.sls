{% if not salt['file.file_exists']('/etc/swift/drive-audit.conf') or not salt['file.file_exists']('/etc/cron.d/swift-drive-audit') %}
/etc/swift/drive-audit.conf:
  file.managed:
    - source: salt://common/storage/drive-audit.conf
    - user: swift
    - group: swift
    - mode: 644
    - require:
      - pkg: common_pkgs
      - pkg: swift_pkgs

/etc/cron.d/swift-drive-audit:
  file.managed:
    - source: salt://common/storage/drive-audit.cron
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: /etc/swift/drive-audit.conf
{% endif %}
