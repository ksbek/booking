angular
  .module 'enapparte'
  .factory 'User', ['railsResourceFactory', 'railsSerializer', (railsResourceFactory, railsSerializer)->
    resource = railsResourceFactory
      url: '/api/v1/users',
      name: 'user'
      interceptors: ['saveIndicatorInterceptor']
      serializer: railsSerializer ()->
        this.nestedAttribute('picture')
        this.resource('picture', 'Picture')

        this.nestedAttribute('addresses')
        this.resource('addresses', 'Address')

        this.nestedAttribute('reviews')
        this.resource('reviews', 'Review')

        this.nestedAttribute('paymentMethods')
        this.resource('paymentMethods', 'PaymentMethod')

    resource.prototype.artist = (id) ->
      resource
        .$get 'api/v1/users/artist', {id: id}
        
    resource.prototype.pictures = (src)->
      resource
        .$post '/api/v1/users/pictures', {src: src}

    resource.prototype.listPictures = ()->
      resource
        .$get '/api/v1/users/list/pictures'

    resource.prototype.destroyPicture = (id)->
      resource
        .$delete '/api/v1/users/picture', {id: id}

    resource.prototype.profilePicture = (src)->
      resource
        .$post '/api/v1/users/profile_picture', {src: src}

    resource.prototype.disconnectStripe = ->
      resource.$delete '/api/v1/users/disconnect-stripe'

    resource
  ]
