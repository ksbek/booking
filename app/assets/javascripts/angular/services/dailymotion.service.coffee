'use strict'

angular
  .module 'enapparte'
  .service 'Dailymotion', ['$http'
    class Dailymotion
      constructor: (@http)->

      getVideoId: (url)->
        m = url.match(/^.+(dailymotion.com|dai.ly)\/(video|hub)\/([^_]+)[^#]*(#video=([^_&]+))?/)
        if m != null
          if m[3] != undefined
            return m[3]
          return m[2]
        ""

      getEmbedUrl: (url)->
        "//www.dailymotion.com/embed/video/" + @getVideoId(url)

      setVideoThumbnail: (data, video, size)=>
        if size == 'medium'
          video.thumbnail = data.thumbnail_medium_url
        else if size == 'large'
          video.thumbnail = data.thumbnail_large_url
        else if size == 'small'
          video.thumbnail = data.thumbnail_small_url

      setThumb: (video, size="medium")=>
        url = "https://api.dailymotion.com/video/#{@getVideoId(video.url)}?fields=thumbnail_#{size}_url"
        @http
          .get url,
            headers:
              'X-CSRF-Token': undefined
          .then(
            (response)=>
              @setVideoThumbnail response.data, video, size
            (response)=>
              if response.status is 200
                @setVideoThumbnail response.data, video, size
              else
                console.error response
          )


  ]
