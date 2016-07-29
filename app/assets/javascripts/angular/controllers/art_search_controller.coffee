class ArtSearchController extends @NGController
  @register window.App, 'ArtSearchController'

  @$inject: [
    '$scope',
    'ArtSelect',
    '$state'
  ]

  init: ->
    @scope.artSelect = @ArtSelect

  isSearchPage: ->
    @state.current.name == "shows.search"

