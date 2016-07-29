class DashboardGalleryPicturesController extends @NGController
  @register window.App, 'DashboardGalleryPicturesController'

  @$inject: [
    '$scope'
    '$sce'
    '$rootScope'
    'Flash'
    '$state'
    'User'
    'Showcase'
    'ngProgressFactory'
  ]

  newPicture:
    src: null

  init: =>
    user = new @User
    user
      .listPictures()
      .then (pictures)=>
        @scope.pictures = pictures
    @scope.trustAsHtml = @sce.trustAsHtml

    @scope.progressbar = @ngProgressFactory.createInstance()

  savePicture: () =>
    scope = @scope
    scope.progressbar.start()
    scope.loading = true
    user = new @User
    user
      .pictures(@scope.newPicture.src)
      .then (result) ->
        scope.pictures.push result
        scope.loading = false
        scope.newPicture = {}
        scope.progressbar.complete()

  removePicture: (picture, index)=>
    scope = @scope
    user = new @User
    user
      .destroyPicture(picture.id)
      .then (response) ->
        scope.pictures.splice(index, 1)
