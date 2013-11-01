account-config:
  account-auditor:
    accounts_per_second: 20
    interval: 10
    log_facility: LOG_LOCAL2
  account-reaper:
    concurrency: 2
    delay_reaping: 60
    conn_timeout: 0.5
