{# Please check ring-master.conf-sample for more options and info #}
ring-master-config:
  ringmasterd:
    user = swift
    log_facility = LOG_LOCAL2
    swiftdir = /etc/swift
    weight_shift = 10.0
    interval = 120
    change_interval = 3600
    change_window = 0000,2400
    balance_threshold = 2.0
    min_seconds_since_change = 120

  ringmaster_wsgi:
    user = swift
    log_path = /var/log/ring-master/wsgi.log
    swiftdir = /etc/swift
    server_ring_port = 8090

ring-minion-config:
  minion:
    user = swift
    log_facility = LOG_LOCAL2
    swiftdir = /etc/swift
    ring_master = http://127.0.0.1:8090/
