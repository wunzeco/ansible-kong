Kong
=============

This role installs and configures Kong.


## Example

```
- hosts: myhost

  vars:
    kong_version: 0.7.0
	kong_cassandra_host: <my_cassandra_ip_or_fqdn>

  roles:
    - wunzeco.kong
```


## Dependencies

none
