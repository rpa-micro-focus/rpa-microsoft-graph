namespace: office365._tools
flow:
  name: http_graph_action
  inputs:
    - url
    - token
    - method
    - body:
        required: false
  workflow:
    - http_client_action:
        do:
          io.cloudslang.base.http.http_client_action:
            - url: "${'https://graph.microsoft.com/v1.0%s' % url}"
            - auth_type: anonymous
            - proxy_host: "${get_sp('proxy_host')}"
            - proxy_port: "${get_sp('proxy_port')}"
            - proxy_username: "${get_sp('proxy_username')}"
            - proxy_password:
                value: "${get_sp('proxy_password')}"
                sensitive: true
            - trust_all_roots: 'false'
            - x_509_hostname_verifier: strict
            - headers: "${'Authorization: Bearer ' + token}"
            - body: '${body}'
            - content_type: application/json
            - method: '${method}'
        publish:
          - return_result
          - error_message
          - status_code
          - return_code
          - response_headers
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - return_result: '${return_result}'
    - response_headers: '${response_headers}'
    - error_message: '${error_message}'
    - status_code: '${status_code}'
    - return_code: '${return_code}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      http_client_action:
        x: 85
        'y': 96
        navigate:
          157930d8-a607-4c4d-9e14-cf9639670613:
            targetId: 4e80e608-6286-2b58-a16a-2847a30b06d5
            port: SUCCESS
    results:
      SUCCESS:
        4e80e608-6286-2b58-a16a-2847a30b06d5:
          x: 253
          'y': 91
