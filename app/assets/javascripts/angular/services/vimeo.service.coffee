angular
  .module 'enapparte'
  .service 'Vimeo', ['$http'
    class Vimeo
      constructor: (@http)->

      getVideoId: (url)->
        m = url.match(/https?:\/\/(?:www\.|player\.)?vimeo.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|video\/|)(\d+)(?:$|\/|\?)/)
        if m != null && m[3] != undefined
          return m[3]
        ""

      getEmbedUrl: (url)->
        "//player.vimeo.com/video/" + @getVideoId(url)

      setVideoThumbnail: (data, video, size)=>
        if size == 'medium'
          video.thumbnail = data[0].thumbnail_medium
        else if size == 'large'
          video.thumbnail = data[0].thumbnail_large
        else if size == 'small'
          video.thumbnail = data[0].thumbnail_small

      setThumb: (video, size="medium")=>
        url = 'https://vimeo.com/api/v2/video/' + @getVideoId(video.url) + '.json?callback=?'
        $.getJSON url, {format: "json"}, (data) =>
          @setVideoThumbnail data, video, size

  ]
