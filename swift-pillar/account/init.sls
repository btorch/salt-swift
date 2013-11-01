account-config:
  DEFAULT:
    bind_ip: 0.0.0.0
    bind_port: 6002
    workers: 6
    swift_dir: /etc/swift
    user: swift
    devices: /srv/node
    disable_fallocate: false
    db_preallocation: off
    fallocate_reserve: 0
    log_statsd_default_sample_rate: 1.0
    log_statsd_host:
    log_statsd_metric_prefix:
    log_statsd_port: 8125
    log_statsd_sample_rate_factor: 1.0

  pipeline:main:
    pipeline: healthcheck recon account-server

  app:account-server:
    use: egg:swift#account
    log_facility: LOG_LOCAL1

  account-auditor:
    accounts_per_second: 100
    interval: 1800
    log_facility: LOG_LOCAL2

  account-reaper:
    concurrency: 2
    conn_timeout: 0.5
    delay_reaping: 604800
    interval: 3600
    log_facility: LOG_LOCAL2
    node_timeout: 10

  account-replicator:
    concurrency: 4
    conn_timeout: 0.5
    error_suppression_interval: 60
    error_suppression_limit: 10
    interval: 30
    log_facility: LOG_LOCAL2
    max_diffs: 100
    node_timeout: 10
    per_diff: 10000
    reclaim_age: 604800
    run_pause: 30

  filter:healthcheck:
    use: egg:swift#healthcheck

  filter:recon:
    use: egg:swift#recon
    log_facility: LOG_LOCAL2
    recon_cache_path: /var/cache/swift
    recon_lock_path: /var/lock/swift
