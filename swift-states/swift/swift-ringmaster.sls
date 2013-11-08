/usr/lib/python2.7/site-packages:
  file.directory:
    - user: root
    - group: root
    - mode: 755

swift-ring-master:
  git.latest:
    - name: https://github.com/pandemicsyn/swift-ring-master.git
    - rev: master
    - target: /usr/local/src/swift-ring-master
    - require:
      - pkg: swift_pkgs
      - file.directory: /usr/lib/python2.7/site-packages

install-swift-ring-master:
  cmd.wait:
    - name: python setup.py install 
    - cwd: /usr/local/src/swift-ring-master
    - shell: /bin/bash
    - require:
      - pkg: swift_pkgs
      - file.directory: /usr/lib/python2.7/site-packages
    - watch:
      - git: swift-ring-master

/var/log/ring-master:
  file.directory:
    - makedirs: True
    - user: swift
    - group: swift
    - require:
      - git: swift-ring-master
      - cmd: install-swift-ring-master

{% if 'admin' in grains['roles'] %}
/etc/swift/ring-master.conf:
  file.managed:
    - source: salt://admin/ring-master.conf
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - reguire:
      - git: swift-ring-master
      - cmd: install-swift-ring-master
      - file.directory: /var/log/ring-master

/etc/init.d/swift-ring-master-server:
  file.copy:
    - name: /etc/init.d/swift-ring-master-server
    - source: /usr/local/src/swift-ring-master/etc/init.d/swift-ring-master-init
    - user: root
    - group: root
    - mode: 755
    - reguire:
      - git: swift-ring-master
      - cmd: install-swift-ring-master
      - file.directory: /var/log/ring-master    

/etc/init.d/swift-ring-master-wsgi:
  file.copy:
    - name: /etc/init.d/swift-ring-master-wsgi
    - source: /usr/local/src/swift-ring-master/etc/init.d/swift-ring-master-wsgi-init
    - user: root
    - group: root
    - mode: 755
    - reguire:
      - git: swift-ring-master
      - cmd: install-swift-ring-master
      - file.directory: /var/log/ring-master    

/etc/init.d/swift-ring-minion:
  file.absent:
    - name: /etc/init.d/swift-ring-minion

swift-ring-master-server:
  service:
    - running
    - sig: swift-ring-master-server
    - enable: True
    - require:
      - git: swift-ring-master
      - file: /etc/swift/ring-master.conf
    - watch:
      - file: /etc/init.d/swift-ring-master-server

swift-ring-master-wsgi:
  service:
    - running
    - sig: swift-ring-master-wsgi-server
    - enable: True
    - require:
      - git: swift-ring-master
      - file: /etc/swift/ring-master.conf
    - watch:
      - file: /etc/init.d/swift-ring-master-wsgi

{% else %}
/etc/swift/ring-minion.conf:
  file.managed:
    - source: salt://common/ring-minion.conf
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - reguire:
      - git: swift-ring-master
      - cmd: install-swift-ring-master
      - file.directory: /var/log/ring-master
{% endif %}
