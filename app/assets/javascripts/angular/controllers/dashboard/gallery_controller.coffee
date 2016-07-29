class DashboardGalleryController extends @NGController
  @register window.App, 'DashboardGalleryController'

  @$inject: [
    '$scope'
    '$sce'
    '$rootScope'
    'Flash'
    '$state'
    'User'
    'Showcase'
    'EmbedVideo'
  ]

  tabsGallery: [
    { heading: 'Music', route: 'dashboard.gallery.music' }
    { heading: 'Video', route: 'dashboard.gallery.video' }
    { heading: 'Pictures', route: 'dashboard.gallery.pictures' }
  ]

  newPicture:
    src: null

  init: =>
    @scope.kind_values = [
      { name:'Dailymotion', value:'Dailymotion', }
      { name:'Youtube', value:'Youtube', }
      { name:'Vimeo', value:'Vimeo', }
    ]
    @scope.showcase = new @Showcase
    @scope.current_music = new @Showcase
    @scope.current_music.kind = "Soundcloud"
    @scope.current_video = new @Showcase
    @scope.current_video.kind = "Dailymotion"
    @Showcase
      .query()
      .then (showcases)=>
        @scope.showcases = showcases
        @scope.musics = showcases.filter (showcase) -> showcase.kind == 'Soundcloud'
        @scope.music = @scope.musics[0]
        @scope.current_music.url = @scope.music && @scope.music['url']
        @scope.videos = showcases.filter (showcase) -> showcase.kind != 'Soundcloud'
    user = new @User
    user
      .listPictures()
      .then (pictures)=>
        @scope.pictures = pictures
    @scope.trustAsHtml = @sce.trustAsHtml

  getEmbedUrl: (video) =>
    @EmbedVideo.getVideoFrame video, 480, 270

  onEditMusicUrl: (event) =>
    if @scope.music && !@scope.current_music.url
      return @scope.removeMusic()

    scope = @scope
    if scope.music
      scope.music.url = scope.current_music.url
    else
      scope.music = scope.current_music
      scope.current_music = new @Showcase
      scope.current_music.url = scope.music.url
      scope.current_music.kind = scope.music.kind
    scope.music
      .save()
      .then (music)=>

  onAddVideoUrl: () =>
    scope = @scope
    if !scope.current_video.url
      return
    kind = scope.current_video.kind
    scope.current_video
      .save()
      .then (video) =>
        scope.videos.push video
        scope.current_video = {}
        scope.current_video = new @Showcase
        scope.current_video.kind = kind

  removeMusic: ()=>
    scope = @scope
    scope.music
      .delete()
      .then (response) ->
        scope.music = null
        scope.current_music.url = ""

  removeVideo: (index) =>
    scope = @scope
    scope.videos[index]
      .delete()
      .then (response) ->
        scope.videos.splice(index, 1)

