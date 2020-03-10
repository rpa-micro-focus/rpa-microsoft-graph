namespace: office365.mail
flow:
  name: list_messages
  inputs:
    - user_principal_name: phishing@rpamf.onmicrosoft.com
    - folder_name:
        required: false
    - top: '2'
  workflow:
    - authenticate:
        do:
          office365.auth.authenticate: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_client_get
    - http_client_get:
        do:
          io.cloudslang.base.http.http_client_get:
            - url: "${'https://graph.microsoft.com/v1.0/users/%s%s/messages%s' % (user_principal_name, '' if not folder_name else '/mailFolders'+folder_name, \"\" if not top else '?$top='+top)}"
            - auth_type: anonymous
            - headers: "${'Authorization: Bearer ' + token}"
            - content_type: application/json
        publish:
          - json: '${return_result}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - json: '${json}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      authenticate:
        x: 110
        'y': 102
      http_client_get:
        x: 300
        'y': 102
        navigate:
          73cf73b4-7c40-cee9-6357-15280d6d1fba:
            targetId: 0de24e87-f841-d198-f608-1f8d4812b488
            port: SUCCESS
    results:
      SUCCESS:
        0de24e87-f841-d198-f608-1f8d4812b488:
          x: 465
          'y': 79
