{% if grains['os_family'] == 'Debian' %}
ubuntu_cloud_repo:
  pkgrepo.managed:
    - order: 3
    - humanname: Ubuntu Cloud Archive (Havana)
    - name: deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main
    - file: /etc/apt/sources.list.d/openstack_havana.list
    - dist: precise-updates/havana

{% elif grains['os_family'] == 'Redhat' %}
epel_repo:
  pkgrepo.managed:
    - order: 3
    - humanname: Extra Packages for Enterprise Linux
    - mirrorlist: http://mirrors.fedoraproject.org/mirrorlist?repo=epel-6&arch=$basearch
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

epel_openstack_repo:
  pkgrepo.managed:
    - order: 4
    - humanname: OpenStack Havana Repository for EPEL 6
    - mirrorlist: http://repos.fedorapeople.org/repos/openstack/openstack-havana/epel-6
    - gpgcheck: 0
{% endif %}
