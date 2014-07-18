class ex.Cloud extends ex.Orbitable
  getStyle: (front, x, y, rotate, dist) ->
    scale = Math.abs Math.cos(ex.deg2rad dist / 128 * 90)
    shadow = (5+@altitude) * 1 / scale
    ratio = (1-scale)
    r3 = ratio * ratio * ratio
    r = 255 - Math.round r3 * (255 - 0x8f)
    g = 255 - Math.round r3 * (255 - 0xed)
    b = 255 - Math.round r3 * (255 - 0xf4)

    transform = @getTransform rotate, Math.max scale, 0.3

    "#{transform} background: rgb(#{r},#{g},#{b}); box-shadow: 0 0 4px 1px rgb(#{r},#{g},#{b}), 0 0 8px 1px rgb(#{r},#{g},#{b});"

  getShadowStyle: (front, x, y, rotate, dist) ->
    scale = Math.abs Math.cos(ex.deg2rad dist / 128 * 90)

    transform = @getTransform rotate, Math.max scale, 0.0001

    if front
      transform
    else
      'display: none;'

  getTransform: (rotate, scale) ->
    transformString = "rotate(#{Math.round ex.rad2deg rotate}deg) scale(#{scale}, 1)"
    prefixes = ['', '-o-', '-ms-', '-moz-', '-webkit-']
    prefixes.map((p) -> "#{p}transform: #{transformString};").join('')
