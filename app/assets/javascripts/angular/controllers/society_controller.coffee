class SocietyController extends @NGController
  @register window.App, 'SocietyController'

  @$inject: [
    '$scope'
    '$http'
  ]

  init: ->
    @scope.society = {}

  submit: ()=>
    scope = @scope

    @http(
      method: 'POST'
      url: '/society'
      data: {society:scope.society}).then ((response) ->
      scope.society = {}
      return
    ), (response) ->
      return

