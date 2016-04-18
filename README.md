Kong
=============

This role installs and configures Kong.


## Example

### Install Kong

```
- hosts: konghost

  vars:
    kong_version: 0.7.0
	kong_cassandra_host: <my_cassandra_ip_or_fqdn>

  roles:
    - wunzeco.kong
```

### Add/Update/Delete API Object in Kong

```
- hosts: myhost

  roles:
    ##   ====>>                   ADD/UDPDATE an API object in Kong
    - role: ansible-kong
      kong_task: api
      kong_api_obj_name: serviceOne
      kong_api_obj_upstream_url: "https://service-upstream.ogonna.com"
      kong_api_obj_request_path: "/serviceOne"

    ##   ====>>                   DELETE an API object in Kong
    - role: ansible-kong
      kong_task: api
      kong_api_obj_name: serviceThree
      kong_api_obj_upstream_url: "https://service-upstream.ogonna.com"
      kong_api_obj_request_path: "/serviceThree"
      kong_delete_api_obj: true
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
