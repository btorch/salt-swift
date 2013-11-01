container-config:
  DEFAULT:
    backlog: 4096
    bind_ip: 0.0.0.0
    bind_port: 6001
    workers: 6
    user: swift
    swift_dir: /etc/swift
    devices: /srv/node
    db_preallocation: off
    disable_fallocate: false
    fallocate_reserve: 0
    log_statsd_default_sample_rate: 1.0
    log_statsd_host:
    log_statsd_metric_prefix:
    log_statsd_port: 8125
    log_statsd_sample_rate_factor: 1.0

  pipeline:main:
    pipeline: healthcheck recon container-server

  app:container-server:
    use: egg:swift#container
    log_facility: LOG_LOCAL1
    allow_versions: true
    conn_timeout: 0.5
    node_timeout: 3

  container-auditor:
    log_facility: LOG_LOCAL2
    containers_per_second: 200
    interval: 1800

  container-replicator:
    log_facility: LOG_LOCAL2
    concurrency: 6
    conn_timeout: 0.5
    interval: 30
    max_diffs: 100
    node_timeout: 15
    per_diff: 1000
    reclaim_age: 604800

  container-updater:
    log_facility: LOG_LOCAL2
    concurrency: 4
    account_suppression_time: 60
    conn_timeout: 5
    interval: 300
    node_timeout: 15

  filter:healthcheck:
    use: egg:swift#healthcheck

  filter:recon:
    use: egg:swift#recon
    log_facility: LOG_LOCAL2
    recon_cache_path: /var/cache/swift
    recon_lock_path: /var/lock/swift
