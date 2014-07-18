#= require pixi.dev
#= require ./planets/utils

WIDTH = 400
HEIGHT = 300

playing = false


$ ->
  $canvas = $('#canvas')
  $stage = $('#stage')

  stage = new PIXI.Stage(0x000000)

  renderer = PIXI.autoDetectRenderer(WIDTH, HEIGHT)

  $stage.append(renderer.view)

  texture = PIXI.Texture.fromImage('images/0.png')
  planet = new PIXI.Sprite(texture)

  planet.position.x = 0
  planet.position.y = 0

  stage.addChild planet

  window.animate = ->
    renderer.render(stage)
    setTimeout (-> requestAnimationFrame animate if playing), 0

  animate()
