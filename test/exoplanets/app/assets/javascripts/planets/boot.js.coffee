#= require ./utils
#= require ./random
#= require ./orbitable
#= require ./cloud
#= require ./planet

createCluster = (planet, lat, lng, count) ->
  speed = 50+Math.random()*5
  for i in [0..count]
    cloud = new ex.Cloud lat + Math.random()*30, lng+Math.random()*30, 0, speed, 3 + Math.random() * 10
    cloud.build()

    planet.addOrbitable cloud

createPlanet = (id=0) ->
  planet = new ex.Planet id

  body = document.getElementById('stage')

  body.appendChild planet.build()

  for i in [0..10]
    createCluster planet, 180-Math.random()*360, 180-Math.random()*360, 1+Math.random() * 10

  body.onclick = ->
    console.log('click')
    window.playing = not window.playing
    window.animate() if window.playing

  planet

window.playing = false

window.onload = ->
  # planets = (createPlanet(Math.round(Math.random()* 4)) for i in [0..3])
  planets = [createPlanet 0]

  window.animate = ->
    planets.forEach (planet) ->
      planet.animate(new Date().getTime())

    setTimeout (-> requestAnimationFrame animate if playing), 0

  animate()

