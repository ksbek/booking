'use strict'

angular
  .module 'enapparte'
  .service 'Youtube', ['$http'
    class Youtube
      constructor: (@http)->

      getVideoId: (url)->
        match = url.match(/^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/)
        if match && match[7] && match[7].length == 11
          return match[7]
        ""

      getEmbedUrl: (url)->
        "//www.youtube.com/embed/" + @getVideoId(url)

      setThumb: (video, size="medium")=>
        video.thumbnail = "//img.youtube.com/vi/#{@getVideoId(video.url)}/0.jpg"


  ]
