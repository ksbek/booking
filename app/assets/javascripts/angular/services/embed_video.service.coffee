angular
  .module 'enapparte'
  .service 'EmbedVideo', ['Youtube', 'Dailymotion', 'Vimeo', '$sce',
    class EmbedVideo
      constructor: (@Youtube, @Dailymotion, @Vimeo, @sce)->

      getVideoFrame: (video, width, height)=>
        embed_url = null
        if video.kind == "Dailymotion"
          embed_url = @Dailymotion.getEmbedUrl(video.url)
        else if video.kind == "Youtube"
          embed_url = @Youtube.getEmbedUrl(video.url)
        else if video.kind == "Vimeo"
          embed_url = @Vimeo.getEmbedUrl(video.url)

        if embed_url
          return @sce.trustAsHtml "<iframe frameborder='0' height='#{height}' width='#{width}' src='#{embed_url}'></iframe>"
        ""

      setThumbnail: (video, size="medium")=>
        if video.kind == "Dailymotion"
          @Dailymotion.setThumb(video, size)
        else if video.kind == "Youtube"
          @Youtube.setThumb(video, size)
        else if video.kind == "Vimeo"
          @Vimeo.setThumb(video, size)

  ]
