########################################################################################################################
#!!
#! @input user_principal_name: Unique identifier of the user
#! @input force_change_password: Force the user to change his/her password first time he/she signs in
#!!#
########################################################################################################################
namespace: office365.user
flow:
  name: create_user
  inputs:
    - display_name: Test
    - mail_nick_name: test
    - user_principal_name: test@rpamf.onmicrosoft.com
    - password:
        sensitive: true
    - force_change_password: 'false'
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
            - method: POST
            - body: |-
                ${'''
                {
                  "accountEnabled": true,
                  "displayName": "%s",
                  "mailNickname": "%s",
                  "userPrincipalName": "%s",
                  "passwordProfile" : {
                    "forceChangePasswordNextSignIn": %s,
                    "password": "%s"
                  }
                }
                ''' % (display_name, mail_nick_name, user_principal_name, force_change_password, password)}
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
      http_graph_action:
        x: 229
        'y': 83
        navigate:
          297032fa-a883-67fe-0ef2-c59f849f7d77:
            targetId: f9ca98c4-3b22-08dc-b07e-53dfa4d7d54f
            port: SUCCESS
      authenticate:
        x: 55
        'y': 88
    results:
      SUCCESS:
        f9ca98c4-3b22-08dc-b07e-53dfa4d7d54f:
          x: 393
          'y': 81
