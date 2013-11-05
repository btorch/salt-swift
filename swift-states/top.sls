base:
  '*':
    - common
    - swift
  'roles:admin'
    - match: grain
    - swift
    - admin
  'roles:account'
    - match: grain
    - account
  'roles:container'
    - match: grain
    - container
  'roles:object'
    - match: grain
    - object
  'roles:proxy'
    - match: grain
    - proxy
