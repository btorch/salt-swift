proxy-config:
  DEFAULT:
    backlog: 4096
    workers: 12
    bind_ip: 0.0.0.0
    bind_port: 8080
    log_statsd_default_sample_rate: 1.0
    log_statsd_host:
    log_statsd_metric_prefix:
    log_statsd_port: 8125
    log_statsd_sample_rate_factor: 1.0

  pipeline:main:
    pipeline: catch_errors proxy-logging healthcheck cache ratelimit authtoken keystoneauth proxy-logging proxy-server

  app:proxy-server:
    use: egg:swift#proxy
    log_facility: LOG_LOCAL0
    client_timeout: 60
    conn_timeout: 3.5
    error_suppression_interval: 60
    error_suppression_limit: 10
    node_timeout: 60
    object_post_as_copy: true
    account_autocreate: true
    allow_account_management: false

  filter:authtoken:
    paste.filter_factory: keystoneclient.middleware.auth_token:filter_factory
    admin_password: hello
    admin_tenant_name: services
    admin_user: tokenvalidator
    auth_host: 192.168.4.20
    auth_port: 5000
    auth_protocol: http
    cache: swift.cache
    delay_auth_decision: 1
    signing_dir: /var/cache/swift
    token_cache_time: 86100

  filter:keystoneauth:
    use: egg:swift#keystoneauth
    operator_roles: admin, swiftoperator
    reseller_admin_role: reseller_admin

  filter:cache:
    use: egg:swift#memcache
    memcache_serialization_support: 2
    memcache_servers: 192.168.4.13:11211,192.168.4.9:11211,192.168.4.7:11211

  filter:account-quotas:
    use: egg:swift#account_quotas

  filter:bulk:
    use: egg:swift#bulk

  filter:catch_errors:
    use: egg:swift#catch_errors

  filter:cname_lookup:
    use: egg:swift#cname_lookup

  filter:container-quotas:
    use: egg:swift#container_quotas

  filter:domain_remap:
    use: egg:swift#domain_remap

  filter:formpost:
    use: egg:swift#tempurl

  filter:healthcheck:
    use: egg:swift#healthcheck

  filter:list-endpoints:
    use: egg:swift#list_endpoints

  filter:name_check:
    use: egg:swift#name_check

  filter:proxy-logging:
    use: egg:swift#proxy_logging

  filter:ratelimit:
    use: egg:swift#ratelimit

  filter:slo:
    use: egg:swift#slo

  filter:staticweb:
    use: egg:swift#staticweb

  filter:tempurl:
    use: egg:swift#tempurl

