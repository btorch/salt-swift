ubuntu_cloud_repo:
  pkgrepo.managed:
    - order: 2
    - humanname: Ubuntu Cloud Archive (Havana)
    - name: deb http://ubuntu-cloud.archive.canonical.com/ubuntu precise-updates/havana main
    - file: /etc/apt/sources.list.d/openstack_havana.list
    - dist: precise-updates/havana
