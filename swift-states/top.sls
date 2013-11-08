base:
  '*':
    - common
    - swift
    - swift-ring
  'roles:admin':
    - match: grain
    - admin
  'roles:account':
    - match: grain
    - account
  'roles:container':
    - match: grain
    - container
  'roles:object':
    - match: grain
    - object
  'roles:proxy':
    - match: grain
    - proxy
