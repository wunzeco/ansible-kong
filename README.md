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


## Testing

To run this role's integration tests

```
kitchen verify && kitchen destroy
```

> **Note:**
>   `kitchen test` command is not appropriate because both kitchen suites 
>   (instances) need to be up and running for all tests to pass.


## Dependencies

none
