class RootController extends @NGController
  @register window.App, 'RootController'

  @$inject: [
    '$scope',
    '$rootScope',
    '$state',
    'ArtSelect',
    '$timeout'
  ]

  init: ->
    @scope.art = {}
    @rootScope.rootPath = true
    @scope.artSelect = @ArtSelect
    @scope.endDate = null

  beginSearch: =>
    artId = if @scope.artSelect.selected then @scope.artSelect.selected.id else null
    @state.go 'shows.search',
      id: artId
      endDate: @scope.endDate || null
