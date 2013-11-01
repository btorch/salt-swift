swift_pkgs:
  pkg.installed:
    - require:
      - pkg: common_pkgs
    - skip_verify: True
    - pkgs:
      - python-greenlet
      - python-eventlet
      - python-dnspython
      - python-swiftclient
      {% if grains['os_family'] == 'Debian' %}
      - python-swift
      - swift
      - swift-doc
      {% elif grains['os_family'] == 'Redhat' %}
      - openstack-swift
      - openstack-swift-doc
      {% endif %}

/etc/swift:
  file.directory:
    - makedirs: True
    - user: swift
    - group: swift
    - mode: 755
    - require:
      - pkg: swift_pkgs

/etc/swift/swift.conf:
  file.managed:
    - source: salt://common/swift.conf
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - require: 
      - file: /etc/swift

/var/run/swift:
  file.directory:
    - makedirs: True
    - mode: 775
    - user: swift
    - group: root
    - require: 
      - pkg: swift_pkgs

/var/log/swift:
  file.directory:
    - makedirs: True
    - mode: 755
    - require: 
      - pkg: swift_pkgs

