class ProfileController extends @NGController
  @register window.App, 'ProfileController'

  @$inject: [
    '$scope'
    '$rootScope'
    'Flash'
    'User'
    '$state'
    'ngProgressFactory'
  ]

  tabsReviews: [
    { heading: 'Reçus', route: 'dashboard.profile.reviews.received' }
    { heading: 'Envoyés', route: 'dashboard.profile.reviews.sent' }
  ]

  user: {}
  map: null

  init: =>
    @scope.tabs2 = [
      {
        heading: 'Profil'
        route: 'dashboard.profile.personal'
      }
      {
        heading: 'Commentaires'
        route: 'dashboard.profile.reviews.received'
        isActive: @state.includes.bind(@state, 'dashboard.profile.reviews')
      }
    ]
    @User
      .get(1)
      .then (user)=>
        @scope.user = user

    @scope.progressbar = @ngProgressFactory.createInstance()

  userSave: =>
    if @scope.user
      @scope.user.save()
        .then (user)=>
          @scope.user = user
          @Flash.showNotice @scope, "L'utilisateur a été enregistré avec succès."
        , (error)->
          # @Flash.showError @scope, "L'utilisateur a été enregistré avec succès."

  saveProfilePicture: =>
    @scope.progressbar.start()
    @scope.loading = true
    user = new @User
    user.profilePicture(@scope.user.profilePicture.src)
      .then (profilePicture)=>
        @scope.user.profilePicture = profilePicture
        @scope.loading = false
        @scope.progressbar.complete()
