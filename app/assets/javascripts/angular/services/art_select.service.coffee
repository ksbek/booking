angular
  .module 'enapparte'
  .service 'ArtSelect', ['Art',
    class ArtSelect
      constructor: (@Art) ->
      	@items = []
      	@selected = {title: 'Tous les performeurs'}
      	@Art
          .query()
          .then (arts) =>
            arts.unshift({title: 'Tous les performeurs'})
            @items = arts
  ]
