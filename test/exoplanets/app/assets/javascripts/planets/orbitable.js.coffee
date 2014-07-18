class ex.Orbitable
  constructor: (@lat=0,
                @lng=0,
                @lngVelocity=0,
                @latVelocity=0,
                @altitude=0) ->

  build: ->
    @node = document.createElement 'div'
    @shadowNode = document.createElement 'div'

    @node.className = @getClassName()
    @shadowNode.className = 'shadow'

    [@node, @shadowNode]

  getClassName: -> 'cloud'

  animate: (t) ->
    @lng += @lngVelocity * t
    @lat += @latVelocity * t

    @lng = -180 if @lng >  180
    @lng =  180 if @lng < -180
    @lat = -180 if @lat >  180
    @lat =  180 if @lat < -180

    x = Math.sin(ex.deg2rad @lat) * (128 + @altitude) * Math.abs Math.sin(ex.deg2rad 90+@lng)
    y = Math.cos(ex.deg2rad 90+@lng) * (128 + @altitude)
    xShadow = Math.sin(ex.deg2rad @lat) * 128 * Math.abs Math.sin(ex.deg2rad 90+@lng)
    yShadow = Math.cos(ex.deg2rad 90+@lng) * 128
    dist = Math.max(Math.sqrt(x*x + y*y) - @altitude, 0)
    rotate = Math.atan2 y, x
    front = 90 >= @lat >= -90
    zindex = if front then 10 + Math.round(128 - dist) else 0

    @node.setAttribute 'style', """
      top: #{128+y}px;
      left: #{128+x}px;
      z-index: #{zindex};
      #{@getStyle front, x, y, rotate, dist}
    """.replace /\s+/g, ' '

    @shadowNode.setAttribute 'style', """
      top: #{128+yShadow}px;
      left: #{128+xShadow}px;
      z-index: #{if front then 1 else -1};
      #{@getShadowStyle front, x, y, rotate, dist}
    """.replace /\s+/g, ' '
