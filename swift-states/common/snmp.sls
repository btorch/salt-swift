snmp_pkgs:
  pkg:
    - installed
    - skip_verify: True
    - pkgs:
    {% if grains['os_family'] == 'Debian' %}
      - snmp
      - snmpd
    {% elif grains['os_family'] == 'Redhat' %}
      - net-snmp
      - net-snmp-libs
      - net-snmp-utils
    {% endif %}

snmpd_conf:
  file.managed:
    - name: /etc/snmp/snmpd.conf
    - source: salt://common/snmpd.conf
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    - defaults:
        community_string: openstackRO
        allow_network: 0.0.0.0/0
        sys_location: SwiftCluster
        sys_contact: swiftops
    - require:
      - pkg: snmp_pkgs

snmp_svc:
  service:
    - running
    - reload: True
    - enable: True
    - name: snmpd
    {% if grains['os_family'] == 'Debian' %}
    - sig: ' /usr/sbin/snmpd -Lsd -Lf'
    {% elif grains['os_family'] == 'Redhat' %}
    - sig: '/usr/sbin/snmpd -LS0-6d -Lf'
    {% endif %}
    - require:
      - pkg: snmp_pkgs
      - file.managed: snmpd_conf
