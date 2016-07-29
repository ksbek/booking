class UserSearchController extends @NGController
  @register window.App, 'UserSearchController'

  @$inject: [
    '$scope',
    '$rootScope',
    'Show',
    'Picture',
    'Flash',
    '$filter',
    'ShowArt',
    'UserSearch',
    '_'
    'moment'
    'Auth'
    '$state'
    '$stateParams'
    'ArtSelect'
  ]

  users: []
  arts: []
  filter:
    text: ""
    price: "0,100000"
  priceRadii: [
    {price0: 0, price1: 200, title: '< 200 €'}
    {price0: 200, price1: 400, title: '200 € - 400 €'}
    {price0: 400, price1: 600, title: '400 € - 600 €'}
    {price0: 600, price1: 999999999999, title: '600+ €'}
  ]

  init: ->
    @scope.startDate = @stateParams.startDate || null
    @scope.endDate = @stateParams.endDate || null
    @scope.artId = @stateParams.id || null
    @scope.artSelect = @ArtSelect

    @scope.priceRadius =
      selected: null


    @scope.$watch 'artSelect.items', =>
      if @rootScope.previousState != 'artists.show'
        @scope.artSelect.selected = @scope.artSelect.items[0]
      if @scope.artId
        @scope.artSelect.selected = (@scope.artSelect.items.filter (i) =>
          i.id is + @scope.artId
        )[0]

    @scope.style = ''

    @scope.$watch 'filter.price', (newValue, oldValue) =>
      @search()

    @scope.$watch 'artSelect.selected', =>
      @scope.style =
        if @scope.artSelect.selected && @scope.artSelect.selected.bannerUrl
          'background-image': "url(\"" + @scope.artSelect.selected.bannerUrl + "\")"
        else
          ''
      @search()

    @scope.$watch 'endDate', =>
      @search()

    @scope.$watch 'startDate', =>
      @search()

    @scope.$watch 'priceRadius.selected', =>
      @search()

  artIsChosen: ->
    @scope.artSelect.selected != null

  search: =>
    q = if  @scope.filter.text then '*' + @scope.filter.text + '*' else ''
    art_ids = @scope.arts
      .filter (art)->
        art.checked == true
      .map (art)->
        art.id

    if @scope.priceRadius.selected
      price0 = @scope.priceRadius.selected.price0
      price1 = @scope.priceRadius.selected.price1

    @UserSearch
      .query
        q: q
        # price0: @scope.filter.price.split(',')[0]
        # price1: @scope.filter.price.split(',')[1]
        price0: price0 || null
        price1: price1 || null
        art_id: @scope.artSelect.selected.id if @scope.artSelect.selected
        start_date: @scope.startDate
        end_date: @scope.endDate
      .then (users)=>
        @scope.users = users

  modeDetails: (show)=>
    @state.go 'shows.detail',
      id: show.id
      show: show



