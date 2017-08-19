Kong
=====

This role installs and configures Kong.

Please refer to [Kong documentation](https://getkong.org/docs/) for further
information on API, Consumer and Plugins configuration.

## Example

### Install Kong

```
- hosts: konghost

  vars:
    kong_version: 0.9.9
	kong_cassandra_host: <my_cassandra_ip_or_fqdn>

  roles:
    - wunzeco.kong
```

### Add/Update/Delete API Object in Kong

```
- hosts: myhost

  roles:
    ##   ====>>                   ADD/UPDATE an API object in Kong
    - role: wunzeco.kong
      kong_task: api
      kong_api_obj_name: serviceOne
      kong_api_obj_upstream_url: "https://service-upstream.ogonna.com"
      kong_api_obj_request_path: "/serviceOne"

    ##   ====>>                   DELETE an API object in Kong
    - role: wunzeco.kong
      kong_task: api
      kong_api_obj_name: serviceThree
      kong_api_obj_upstream_url: "https://service-upstream.ogonna.com"
      kong_api_obj_request_path: "/serviceThree"
      kong_delete_api_obj: true

    ##   ====>>                   ADD/UPDATE an API object and enable Plugins for it
    - role: wunzeco.kong
      kong_task: api
      kong_api_obj_name: serviceWithPlugins
      kong_api_obj_upstream_url: "https://service-upstream.ogonna.com"
      kong_api_obj_request_path: "/serviceWithPlugins"
      kong_api_obj_plugins:
      kong_api_obj_plugins:
        - name: acl
          config_parameters:
            - "config.whitelist=groupOne, groupTwo"
        - name: oauth2
          consumer_id:
          config_parameters:
            - "config.enable_authorization_code=true"
            - "config.scopes=email,phone,address"
            - "config.mandatory_scope=true"
        - name: basic-auth
          config_parameters:
            - "config.hide_credentials=true"

    ##   ====>>                   ADD/UPDATE a Consumer object
    - role: wunzeco.kong
      kong_task: consumer
      kong_consumer_obj_username: clientABC

    ##   ====>>                   ADD/UPDATE a Consumer object and manage credentials for authentication plugins enabled
    - role: wunzeco.kong
      kong_task: consumer
      kong_consumer_obj_username:   clientOne
      kong_consumer_obj_custom_id:  consumer123      # Optional
      kong_consumer_obj_acl_groups: [ groupOne, groupTwo ]
      kong_consumer_obj_auth_creds:
        - plugin: oauth2 
          parameters:
            name: auth-service
            client_id: SOME-CLIENT-ID
            client_secret: SOME-CLIENT-SECRET
            redirect_uri: http://some-domain/endpoint/
        - plugin: oauth2 
          parameters:
            name: auth-master
            client_id: ANOTHER-CLIENT-ID
            client_secret: ANOTHER-CLIENT-SECRET
            redirect_uri: http://another-domain/endpoint/
        - plugin: basic-auth 
          parameters:
            username: bob
            password: bobSecret
        - plugin: basic-auth 
          parameters:
            username: jane
            password: janeSecret
        - plugin: key-auth 
          parameters:
            key: "7aed36b073f94313b75005b6ba46c633"
        - plugin: key-auth 
          parameters:
            key: "c7faa3814c864d7d950d70f399cabffc"
        - plugin: hmac-auth 
          parameters:
            username: john
        - plugin: hmac-auth 
          parameters:
            username: flintstone
            secret:   stoneSecret
        - plugin: jwt
          parameters:
            key:       "5addde658a1b4b6e869d57d35dc8b1fd"
            secret:    "30f8825a9f0e44a0bfb18f7dacf0783a"
            algorithm: "HS256"
        - plugin: jwt
          parameters:
            key: "c4221446f5d845f48bd473df8242924b"

    ##   ====>>                   DELETE a Consumer object in Kong
    - role: wunzeco.kong
      kong_task: consumer
      kong_consumer_obj_username: clientTwo
      kong_delete_consumer_obj: true
```


## Testing

To run this role's integration tests

```
PLATFORM=ubuntu                              # OR centos
kitchen verify $PLATFORM && kitchen destroy $PLATFORM
```



## Dependencies

none
