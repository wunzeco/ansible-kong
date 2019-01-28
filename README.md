Kong
=====

This role installs and configures Kong.

Please refer to [Kong documentation](https://getkong.org/docs/) for further
information on Routes, Services, Consumer and Plugins configuration.

> *Breaking Changes:*
>
>     -  new `kong_route_config` variable introduced to decouple service and routes config previously in `kong_service_config`
>     -  structure of `kong_service_config` updated (Breaking change)
>
> For the last version without breaking changes above please use tag [v1.9](https://github.com/wunzeco/ansible-kong/tree/v1.9)

> *WARNING:*
>
>     -  Support for v0.12.x and earlier deprecated and will be removed SOON!!


## Example

### Install Kong

```
- hosts: konghost

  vars:
    kong_version: 0.13.1
    kong_cassandra_host: <my_cassandra_ip_or_fqdn>
    ## OR for postgres backend
    ## kong_database: postgres
    ## kong_pg_host: <my_pg_ip_or_fqdn>

  roles:
    - wunzeco.kong
```


### Add/Update/Delete kong objects

```
- hosts: my-kong-host

  vars:
    kong_version: 0.13.1
    kong_use_old_config_format: false

  roles:
    #*************************#
    #    SERVICES & ROUTES    #
    #*************************#
    - role: ansible-kong            ## ADD/UPDATE service obj for svcOne service
      kong_task: service
      kong_service_config:
        name: svcOne
        url: "https://service-upstream.ogonna.com/svcOne/api"
    - role: ansible-kong            ## ADD route obj for svcOne
      kong_task: route
      kong_route_config:
        name: svcOneRoute1
        service: svcOne
        paths: [ "/svcOne" ]
        hosts: [ "og.com", "ab.com" ]
    - role: ansible-kong            ## ADD route obj for svcOne
      kong_task: route
      kong_route_config:
        name: svcOneRoute2
        service: svcOne
        paths: [ "/svcOnePlus" ]
        methods: [ "GET", "POST", "PUT" ]
    - role: ansible-kong            ## DELETE service obj for svcThree
      kong_task: service
      kong_delete_service_obj: true
      kong_service_config:
        name: svcThree
    #*************************#
    #    UPSTREAM & TARGETS   #
    #*************************#
    - role: ansible-kong            ## ADD/UPDATE upstream obj for svcOne upstream
      kong_task: upstream
      kong_upstream_config:
        name: upstreamOne
        slots: 1000
    - role: ansible-kong            ## ADD target obj for upstreamOne
      kong_task: target
      kong_target_config:
        upstream: upstreamOne
        target: targetOne
        weight: 200
    - role: ansible-kong            ## DELETE upstreamOne with all targets
      kong_task: upstream
      kong_delete_upstream_obj: true
      kong_upstream_config:
        name: upstreamOne
    #*****************#
    #    CONSUMERS    #
    #*****************#
    - role: ansible-kong            ## ADD/UPDATE consumer obj for consumerOne
      kong_use_old_config_format: false
      kong_task: consumer
      kong_consumer_config:
        username: consumerOne
        custom_id: con-1111
    - role: ansible-kong            ## DELETE consumer obj for consumerTwo
      kong_use_old_config_format: false
      kong_task: consumer
      kong_consumer_config:
        username: consumerTwo
      kong_delete_consumer_obj: true
    - role: ansible-kong            ## ADD/UPDATE consumer obj for consumerThree with plugin configs
      kong_use_old_config_format: false
      kong_task: consumer
      kong_consumer_config:
        username: consumerThree
        custom_id: con-3333
        plugins:
          - name: acl
            parameters:
              groups: [ svcOne-user-group ]
          - name: key-auth
            parameters:
              key: "e2f599f74fc4479681e6586a1e644768"
          - name: oauth2
            parameters:
              name: amazing-service
              client_id: AMAZING-CLIENT-ID
              client_secret: AMAZING-CLIENT-SECRET
              redirect_uri: http://amazing-domain/endpoint/
          - name: basic-auth
            parameters:
              username: smith
              password: bobSecret
          - name: hmac-auth
            parameters:
              username: james
          - name: jwt
            parameters:
              key:       "9efdde658a1b4b6e869d57d35dc8d7fb"
              secret:    "1bf8825a9f0e44a0bfb18f7dacf5c43f"
              algorithm: "HS256"
    #****************#
    #    PLUGINS     #
    #****************#
    - role: ansible-kong            ## ADD rate-limiting plugin obj (global)
      kong_task: plugin
      kong_plugin_config:
        name: rate-limiting
        config: { minute: 50, hour: 500 }
      kong_delete_plugin_obj: false
    - role: ansible-kong            ## ADD rate-limiting plugin obj for svcOneRoute1 route
      kong_task: plugin
      kong_plugin_config:
        name: rate-limiting
        route: svcOneRoute1
        config: { minute: 20, hour: 500 }
    - role: ansible-kong            ## ADD/UPDATE rate-limiting plugin obj for svcOne service and consumerOne consumer
      kong_task: plugin
      kong_plugin_config:
        name: rate-limiting
        service: svcOne
        consumer: consumerOne
        config: { minute: 20, hour: 500 }
      kong_delete_plugin_obj: false
    - role: ansible-kong            ## DELETE rate-limiting plugin obj for svcOne service and consumerOne consumer
      kong_task: plugin
      kong_plugin_config:
        name: rate-limiting
        service: svcOne
        consumer: consumerOne
        config: { minute: 20, hour: 500 }
      kong_delete_plugin_obj: true
    - role: ansible-kong            ## ADD plugin obj for svcOne service
      kong_task: plugin
      kong_plugin_config:
        name: oauth2
        service: svcOne
        config:
          enable_authorization_code: true
          scopes: "email,phone,address"
          mandatory_scope: true
    - role: ansible-kong            ## ADD plugin obj for svcOne service
      kong_task: plugin
      kong_plugin_config:
        name: cors
        service: svcOne
        config:
          origins: "*"
          methods: "GET, POST, PATCH, PUT, DELETE"
          headers: "Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Auth-Token, Access-Control-Allow-Origin, Authorization"
          exposed_headers: "X-Auth-Token"
          credentials: true
          max_age: 3600
    - role: ansible-kong            ## ADD plugin obj for svcOne service
      kong_task: plugin
      kong_plugin_config:
        name: basic-auth
        service: svcOne
        config: { hide_credentials: true }
    - role: ansible-kong            ## ADD plugin obj for svcOne service
      kong_task: plugin
      kong_plugin_config:
        name: key-auth
        service: svcOne
        config: { key_names: X-Api-Access-Key }
    - role: ansible-kong            ## ADD plugin obj for svcOne service
      kong_task: plugin
      kong_plugin_config:
        name: acl
        service: svcOne
        config: { whitelist: "svcOne-user-group, another-user-group" }
```


## Testing

To run this role's integration tests

```
PLATFORM=ubuntu-1604      # OR ubuntu-1404, centos
kitchen verify $PLATFORM && kitchen destroy $PLATFORM
```



## Dependencies

none
