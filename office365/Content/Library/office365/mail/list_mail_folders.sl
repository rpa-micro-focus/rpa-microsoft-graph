namespace: office365.mail
flow:
  name: list_mail_folders
  inputs:
    - user_principal_name: phishing@rpamf.onmicrosoft.com
  workflow:
    - authenticate:
        do:
          office365.auth.authenticate: []
        publish:
          - token
        navigate:
          - FAILURE: on_failure
          - SUCCESS: http_graph_action
    - http_graph_action:
        do:
          office365._tools.http_graph_action:
            - url: "${'/users/%s/mailFolders' % user_principal_name}"
            - token: '${token}'
            - method: GET
        publish:
          - json: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
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
      http_graph_action:
        x: 300
        'y': 95
        navigate:
          f5cb9d45-73b8-a8b4-b98f-1f77a2fba12a:
            targetId: 0de24e87-f841-d198-f608-1f8d4812b488
            port: SUCCESS
    results:
      SUCCESS:
        0de24e87-f841-d198-f608-1f8d4812b488:
          x: 465
          'y': 79
