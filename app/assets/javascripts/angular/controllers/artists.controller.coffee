class ArtistsController extends @NGController
  @register window.App, 'ArtistsController'

  @$inject: [
    '$scope'
    '$sce'
    '$uibModal'
    '$uibModalStack'
    '$stateParams'
    '$rootScope'
    '$state'
    'User'
    'Auth'
    'Art'
    'orderByFilter'
    'ArtSelect'
    'EmbedVideo'
  ]

  init: ->

    @scope.artSelect = @ArtSelect

    user_id = @stateParams.id
    user = new @User
    user
      .artist(user_id)
      .then (artist)=>
        @scope.user = artist

        @scope.bannerStyle =
          'background-image' : "url(\"" + @scope.user.art.bannerUrl + "\")"

        @scope.activeSlideIdx = 0
        musics = @scope.user.showcases.filter (showcase) -> showcase.kind == 'Soundcloud'
        @scope.music = musics[0]
        @scope.videos = @scope.user.showcases
          .filter (showcase) -> showcase.kind != 'Soundcloud'

        # sort by price ascending
        if @scope.user.shows.length > 1
          @scope.user.shows = @orderByFilter(@scope.user.shows, 'price', false)
        @generateThumbnails()
        if @scope.videos.length > 0
          @setPreviewVideo @scope.videos[0]

        @scope.artSelect.selected = (@scope.artSelect.items.filter (i) =>
          i.id is + @scope.user.art.id
        )[0]

    @scope.trustAsHtml = @sce.trustAsHtml

    @scope.openGallery = (slides, idx) =>
      @scope.slides = slides
      @scope.activeSlideIdx = idx

      modal = @uibModal.open
        templateUrl: 'artists/gallery-modal-tpl.html'
        scope: @scope
        windowTopClass: 'artist-gallery-modal'

    @scope.$watch 'artSelect.items', =>
      if @scope.user
        @scope.artSelect.selected = (@scope.artSelect.items.filter (i) =>
          i.id is + @scope.user.art.id
        )[0]

    @scope.$watch 'artSelect.selected', =>
      if @scope.user && @scope.artSelect.selected.id != @scope.user.art.id
        @state.go 'shows.search'

  getEmbedUrl: (video) =>
    @EmbedVideo.getVideoFrame video, "100%", 270

  generateThumbnails: =>
    i = @scope.videos.length
    while i > 0
      i--
      @EmbedVideo.setThumbnail @scope.videos[i]

  setPreviewVideo: (video) =>
    @scope.previewVideo = @getEmbedUrl video

  validateFields: (show) =>
    if !show.time || !show.date || show.time == '' || show.date == '' || (show.pricePerson && (show.numberOfGuests == '' || !show.numberOfGuests)) || (show.minAttendees && show.maxSpectators && (show.numberOfGuests < show.minAttendees || show.numberOfGuests > show.maxSpectators)) || (!show.minAttendees && show.maxSpectators && (show.numberOfGuests < 1 || show.numberOfGuests > show.maxSpectators)) || (show.minAttendees && !show.maxSpectators && (show.numberOfGuests < show.minAttendees))
      show.invalid = true
      show.valid = false
    else
      show.invalid = false
      show.valid = true
    show.valid

  bookNow: (show) =>
    if (show)
      show.submitted = true
      if @validateFields(show)
        unless @Auth.isAuthenticated()
          @uibModalStack.dismissAll('closing')
          @uibModal.open
            animation: true
            templateUrl: 'devise/log_in.html'
            controller: 'SignInController'
          .result
          .then ()=>
            @state.go 'shows.payment',
              id: show.id
              date: new Date(show.date + " " + show.time.getHours() + ':' + show.time.getMinutes()).getTime() / 1000
              spectators: show.numberOfGuests
        else
          @state.go 'shows.payment',
            id: show.id
            date: new Date(show.date + " " + show.time.getHours() + ':' + show.time.getMinutes()).getTime() / 1000
            spectators: show.numberOfGuests
    else
      show.invalid = true
      show.valid = false
      show.submitted = true
