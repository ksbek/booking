angular
  .module 'enapparte'
  .factory 'Showcase', ['railsResourceFactory', 'railsSerializer', (railsResourceFactory, railsSerializer)->
    resource = railsResourceFactory
      url: '/api/v1/showcases',
      name: 'showcase'
      serializer: railsSerializer ()->

    resource
  ]
