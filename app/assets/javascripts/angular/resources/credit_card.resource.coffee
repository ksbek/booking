angular
  .module 'enapparte'
  .factory 'CreditCard', ['railsResourceFactory', 'railsSerializer', (railsResourceFactory, railsSerializer)->
    resource = railsResourceFactory
      url: '/api/v1/credit_cards',
      name: 'credit_card'
      interceptors: ['saveIndicatorInterceptor']

    resource.updateDefault = (id) =>
      resource.$patch "/api/v1/credit_cards/#{id}/make_default"

    resource
  ]
