object-config:
  DEFAULT:
    backlog: 4096
    workers: 8
    bind_ip: 0.0.0.0
    bind_port: 6000
    user: swift
    devices: /srv/node
    swift_dir: /etc/swift
    disable_fallocate: false
    fallocate_reserve: 0
    log_statsd_default_sample_rate: 1.0
    log_statsd_host:
    log_statsd_metric_prefix:
    log_statsd_port: 8125
    log_statsd_sample_rate_factor: 1.0

  pipeline:main:
    pipeline: healthcheck recon object-server

  app:object-server:
    use: egg:swift#object
    log_facility: LOG_LOCAL1
    conn_timeout: 0.5
    mb_per_sync: 64
    node_timeout: 3

  object-auditor:
    log_facility: LOG_LOCAL2
    recon_cache_path: /var/cache/swift
    recon_enable: yes

  object-replicator:
    log_facility: LOG_LOCAL2
    concurrency: 6
    http_timeout: 60
    lockup_timeout: 1800
    reclaim_age: 60
    recon_cache_path: /var/cache/swift
    recon_enable: yes
    rsync_io_timeout: 30
    rsync_timeout: 900
    run_pause: 30

  object-updater:
    log_facility: LOG_LOCAL2
    concurrency: 3
    conn_timeout: 5
    node_timeout: 60
    recon_cache_path: /var/cache/swift
    recon_enable: yes
    slowdown: 0.01

  filter:healthcheck:
    use: egg:swift#healthcheck

  filter:recon:
    use: egg:swift#recon
    log_facility: LOG_LOCAL2
    recon_cache_path: /var/cache/swift
    recon_lock_path: /var/lock/swift
