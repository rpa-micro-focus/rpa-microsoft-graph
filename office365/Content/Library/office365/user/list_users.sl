namespace: office365.user
flow:
  name: list_users
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
            - url: /users
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
        'y': 101
      http_graph_action:
        x: 300
        'y': 119
        navigate:
          0d6410c8-cf40-3261-e842-8dd338ed2d10:
            targetId: 0de24e87-f841-d198-f608-1f8d4812b488
            port: SUCCESS
    results:
      SUCCESS:
        0de24e87-f841-d198-f608-1f8d4812b488:
          x: 465
          'y': 79
