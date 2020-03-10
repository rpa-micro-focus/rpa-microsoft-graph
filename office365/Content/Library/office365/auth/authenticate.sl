namespace: office365.auth
flow:
  name: authenticate
  workflow:
    - encode_client_id:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: "${get_sp('client_id')}"
        publish:
          - client_id_q: '${result}'
        navigate:
          - SUCCESS: encode_client_secret
          - FAILURE: on_failure
    - http_client_post:
        worker_group: '${json}'
        do:
          io.cloudslang.base.http.http_client_post:
            - url: "${'https://login.microsoftonline.com/%s/oauth2/v2.0/token' % tenant_q}"
            - body: "${'client_id=%s&client_secret=%s&scope=https%%3A%%2F%%2Fgraph.microsoft.com%%2F.default&grant_type=client_credentials' % (client_id_q, client_secret_q)}"
            - content_type: application/x-www-form-urlencoded
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: json_path_query
          - FAILURE: on_failure
    - encode_client_secret:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: "${get_sp('client_secret')}"
        publish:
          - client_secret_q: '${result}'
        navigate:
          - SUCCESS: encode_tenant
          - FAILURE: on_failure
    - encode_tenant:
        do:
          io.cloudslang.base.http.url_encoder:
            - data: "${get_sp('tenant')}"
        publish:
          - tenant_q: '${result}'
        navigate:
          - SUCCESS: http_client_post
          - FAILURE: on_failure
    - json_path_query:
        do:
          io.cloudslang.base.json.json_path_query:
            - json_object: '${json}'
            - json_path: $.access_token
        publish:
          - token: '${return_result[1:-1]}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - token: '${token}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      encode_client_id:
        x: 77
        'y': 81
      http_client_post:
        x: 250
        'y': 95
      encode_client_secret:
        x: 69
        'y': 253
      encode_tenant:
        x: 245
        'y': 253
      json_path_query:
        x: 403
        'y': 94
        navigate:
          3a1297cd-67a7-3d27-3a5d-2866036f849d:
            targetId: 485ebac4-02cf-79f7-0aa5-95071b8c6e0c
            port: SUCCESS
    results:
      SUCCESS:
        485ebac4-02cf-79f7-0aa5-95071b8c6e0c:
          x: 409
          'y': 273
