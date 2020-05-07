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
          - SUCCESS: http_graph_action
    - http_graph_action:
        do:
          office365._tools.http_graph_action:
            - url: "${'/users/%s%s/messages%s' % (user_principal_name, '' if not folder_name else '/mailFolders'+folder_name, \"\" if not top else '?$top='+top)}"
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
        x: 289
        'y': 96
        navigate:
          936d4249-beaf-485b-c21e-8916df2ba740:
            targetId: 0de24e87-f841-d198-f608-1f8d4812b488
            port: SUCCESS
    results:
      SUCCESS:
        0de24e87-f841-d198-f608-1f8d4812b488:
          x: 465
          'y': 79
