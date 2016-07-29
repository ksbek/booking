angular
  .module 'enapparte'
  .factory 'UserSearch', ['RailsResource', 'railsSerializer', (RailsResource, railsSerializer)->
    class UserSearch extends RailsResource
      @configure
        url: '/api/v1/users/search',
        name: 'user'
        serializer: railsSerializer () ->
          this.nestedAttribute('user')
  ]
