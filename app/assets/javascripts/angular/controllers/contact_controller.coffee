class ContactController extends @NGController
  @register window.App, 'ContactController'

  @$inject: [
    '$scope'
    'Flash'
    '$rootScope'
    'ArtSelect'
    '$http'
    '$state'
  ]

  init: ->
    @scope.art = {}
    @rootScope.rootPath = true
    @scope.artSelect = @ArtSelect
    @scope.endDate = null
    @scope.contact = {}

  submitContact: ()=>
    flash = @Flash
    scope = @scope

    @http(
      method: 'POST'
      url: '/contact'
      data: {contact:scope.contact}).then ((response) ->
      flash.showSuccess scope, 'Contact mail has been sent successfully.'
      scope.contact = {}
      return
    ), (response) ->
      return

  beginSearch: =>
    artId = if @scope.artSelect.selected then @scope.artSelect.selected.id else null
    @state.go 'shows.search',
      id: artId
      endDate: @scope.endDate || null
