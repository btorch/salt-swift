swift-ring-master:
  git.latest:
    - name: https://github.com/pandemicsyn/swift-ring-master.git
    - rev: master
    - target: /usr/local/src/swift-ring-master
  cmd.wait:
    - name: python setup.py install --prefix=/usr
    - cwd: /usr/local/src/swift-ring-master
    - shell: /bin/bash
    - watch:
      - git: swift-ring-master

/var/log/ring-master:
  file.directory:
    - makedirs: True
    - user: swift
    - group: swift

{% if 'admin' in grains['roles'] %}
/etc/swift/ring-master.conf:
  file.managed:
    - source: salt://admin/ring-master.conf
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - reguire:
      - git.latest: swift-ring-master
      - cmd.wait: swift-ring-master
      - file.directory: /var/log/ring-master

/etc/init.d/swift-ring-master-init:
  file.copy:
    - name: /etc/init.d/swift-ring-master-init
    - source: /usr/local/src/swift-ring-master/etc/init.d/swift-ring-master-init
    - user: root
    - group: root
    - mode: 755
    - reguire:
      - git.latest: swift-ring-master
      - cmd.wait: swift-ring-master
      - file.directory: /var/log/ring-master    

/etc/init.d/swift-ring-master-wsgi-init:
  file.copy:
    - name: /etc/init.d/swift-ring-master-wsgi-init
    - source: /usr/local/src/swift-ring-master/etc/init.d/swift-ring-master-wsgi-init
    - user: root
    - group: root
    - mode: 755
    - reguire:
      - git.latest: swift-ring-master
      - cmd.wait: swift-ring-master
      - file.directory: /var/log/ring-master    
{% else %}
/etc/swift/ring-minion.conf:
  file.managed:
    - source: salt://common/ring-minion.conf
    - user: swift
    - group: swift
    - mode: 644
    - template: jinja
    - reguire:
      - git.latest: swift-ring-master
      - cmd.wait: swift-ring-master
      - file.directory: /var/log/ring-master
{% endif %}
